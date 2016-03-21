Given "the following movies exist" do |movies_table|
     movies_table.hashes.each do |movie|
            Movie.create movie
     end
end

Then "the director of $a should be $b" |movie, director|
    if Movie.find_by(title: movie, director: director) == nil
        return false
    else
        return true
    end
end