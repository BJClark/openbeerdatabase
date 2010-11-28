class User < ActiveRecord::Base
  has_many :beers
  has_many :brewers

  validates :token, :presence => true

  attr_protected :token

  before_validation :generate_token, :on => :create

  protected

  def generate_token
    self.token ||= Digest::SHA256.hexdigest("-#{id}--#{Time.now.to_i}--#{rand}-")
  end
end
