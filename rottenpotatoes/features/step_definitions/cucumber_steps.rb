Given(/^the following movies exist:$/) do |movies_table|
     movies_table.hashes.each do |movie|
            Movie.create movie
     end
end

Then "the director of $a should be $b" do |movie, director|
    mov = Movie.find_by_title(movie)
    if mov == nil
       false
    else
        if mov.director == director
            true
        else
            false
        end
    end
end

Given "I am on the home page" do
    visit movies_path
end

#Then "I should be on the Similar Movies page for \"@a\"" do |movie|
#    mov = Movie.find_by_title(movie)
#    current_path.should == path_to('/movies/same_director?id='+mov.id)
#end

When "I go to the edit page for \"$a\"" do |movie|
    mov = Movie.find_by_title(movie)
    puts edit_movie_path(mov)
    visit (edit_movie_path(mov))
end

When "I go to the details page for\"$a\"" do |movie|
    mov = Movie.find_by_title(movie)
    visit movie_path(mov)
end

Given "I am on the details page for \"$a\"" do |movie|
    mov = Movie.find_by_title(movie)
    visit movie_path(mov)
end