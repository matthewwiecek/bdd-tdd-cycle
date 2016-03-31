require 'spec_helper'

describe 'route same director', :type => :routing do
  it 'routes GET /movies/same_director to movies#same_director' do
     expect(get '/movies/same_director').to route_to(controller: 'movies', action: 'same_director')
  end
end

describe MoviesController, :type => :controller do
  let!(:first_movie) { Movie.create(:title => "Movie 2", :release_date => '2016-01-01 [12:13:06]', :rating => 'G', :director => "James Cameron") }
  let!(:second_movie) { Movie.create(:title => "Movie 1", :rating => 'G', :release_date => '2015-03-20 [12:00:00]', :director => "James Cameron") }
  let!(:third_movie) { Movie.create(:title => "Movie 3", :rating => 'PG', :release_date => '2016-02-05 [00:00:00]', :director => nil) }
  
  describe 'GET same director' do
   
    context "director exists" do
      before(:each) {get :same_director, :id => '1'}
      it "lists movies with same director" do
        expect(response).to render_template("same_director")
      end
    end
    context "director is blank" do
      before(:each) {get :same_director, :id => '3'}
      
      it 'redirects to fail path' do
        expect(response).to redirect_to(movies_path)
      end
      
      it 'will set flash[:error]' do
        expect(flash[:warning]).to be_present
      end
    end
  end
  
  describe 'GET index' do
    
    context 'sorted' do
      
      it 'by title' do
        get :index, :sort => 'title'
        #get redirects the first time to set session
        get :index, :sort => 'title'
        movies = assigns(:movies)
        sorted = movies.sort { |a,b| a.title <=> b.title }
        expect(movies).to eq(sorted)
      end
      it 'by release date' do
        get :index, :sort => 'release_date'
        #get redirects the first time to set session
        get :index, :sort => 'release_date'
        movies = assigns(:movies)
        sorted = movies.sort { |a,b| a.release_date <=> b.release_date }
        expect(movies).to eq(sorted)
      end
    end
    
    context 'filter ratings' do
      it 'get all' do
        get :index, :ratings => Hash[Movie.all_ratings.map {|rating| [rating, rating]}]
        #get redirects the first time to set session
        get :index, :ratings => Hash[Movie.all_ratings.map {|rating| [rating, rating]}]
        movies = assigns(:movies)
        expect(movies.size).to eq(Movie.count)
      end
      
      it 'get only g' do
        get :index, :ratings => { :G => 1 }
        #get redirects the first time to set session
        get :index, :ratings => { :G => 1 }
        movies = assigns(:movies)
        movies.each do |mov|
          expect(mov.rating).to eq('G')
        end
      end
      
      it 'get only pg' do
        get :index, :ratings => { :PG => 1 }
        #get redirects the first time to set session
        get :index, :ratings => { :PG => 1 }
        movies = assigns(:movies)
        movies.each do |mov|
          expect(mov.rating).to eq('PG')
        end
      end
      
    end
  end
  
  describe 'record manipulation' do
    
    it 'create new record' do
      post :create, :movie => {:title => 'mov7', :rating => 'R', :director => "Asriel Dreemuur"}
      expect(Movie.find_by_director("Asriel Dreemuur").director).to eq('Asriel Dreemuur')
    end
    
    it 'delete record' do
      id = Movie.find_by_title('Movie 2').id
      put :update, :id => id, :movie => {:title => "m", :release_date => '2016-01-01 [12:13:06]', :rating => 'G', :director => "James Cameron"}
      expect(Movie.find(id).title).to eq('m')
    end
  end
  
end

describe Movie do
  let!(:first_movie) { Movie.create(:title => "Movie 1", :rating => 'G', :director => "James Cameron") }
  let!(:second_movie) { Movie.create(:title => "Movie 2", :rating => 'G', :director => "James Cameron") }
  let!(:third_movie) { Movie.create(:title => "Movie 3", :rating => 'G', :director => nil) }
  let(:prng) {prng = Random.new()}
  
  describe 'test for same director' do
    it 'returns movies with same director' do
      same = Movie.same_director(prng.rand(1..3))
      director = same[0].director
      same.each do |movie|
        movie.director.should eq(director)
      end
    end
  end
end