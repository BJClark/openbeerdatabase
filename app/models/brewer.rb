class Brewer < ActiveRecord::Base
  belongs_to :user

  validates :name, :presence => true, :length => { :maximum => 255 }

  attr_accessible :name
end
