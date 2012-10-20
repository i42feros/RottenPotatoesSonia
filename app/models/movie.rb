class Movie < ActiveRecord::Base
  def self.allRatings
    self.select(:rating).map do |value|
      value.rating
    end.uniq
  end
end
