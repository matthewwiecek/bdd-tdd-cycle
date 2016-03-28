Given(/^the following movies exist:$/) do |movies_table|
     movies_table.hashes.each do |movie|
            Movie.create movie
     end
end

Then "the director of $a should be $b" do |movie, director|
    if Movie.find_by(title: movie, director: director) == nil
        return false
    else
        return true
    end
end

When "I go to the edit page for \"$a\"" do |movie|
    mov = Movie.find_by_title(movie)
    visit (movie_path(mov) + '/edit')
end

When "I go to the details page for\"$a\"" do |movie|
    mov = Movie.find_by_title(movie)
    visit movie_path(mov)
end

Given "I am on the details page for \"$a\"" do |movie|
    mov = Movie.find_by_title(movie)
    visit movie_path(mov)
end