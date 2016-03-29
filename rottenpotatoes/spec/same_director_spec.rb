require 'spec_helper'

describe 'route same director', :type => :routing do
  it 'routes GET /movies/same_director to movies#same_director' do
     expect(get '/movies/same_director').to route_to(controller: 'movies', action: 'same_director')
  end
end

describe MoviesController, :type => :controller do
  let!(:first_movie) { Movie.create(:title => "Movie 1", :rating => 'G', :director => "James Cameron") }
  let!(:second_movie) { Movie.create(:title => "Movie 2", :rating => 'G', :director => "James Cameron") }
  let!(:third_movie) { Movie.create(:title => "Movie 3", :rating => 'G', :director => nil) }
  
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