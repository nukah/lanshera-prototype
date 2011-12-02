class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :service
  has_many :comments
end
