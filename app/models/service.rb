class Service < ActiveRecord::Base
  attr_accessible :login, :password
  belongs_to :user
end
