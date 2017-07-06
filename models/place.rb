class Place < ActiveRecord::Base
  validates :place_id, uniqueness: {message: "is in the database already"}, presence: true
end
