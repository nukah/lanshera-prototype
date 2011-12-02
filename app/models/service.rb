class Service < ActiveRecord::Base
  belongs_to :user
  has_many :posts
  validates :login, :password, :presence => true
  validates :password, :length => { :in => 6..30 }
end
