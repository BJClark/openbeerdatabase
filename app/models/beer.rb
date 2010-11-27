class Beer < ActiveRecord::Base
  belongs_to :user

  validates :name, :presence => true, :length => { :maximum => 255 }

  attr_accessible :name

  def self.search(options = {})
    paginate(options_for_search(options))
  end

  def as_json(options = {})
    { :id   => id,
      :name => name }
  end

  private

  def self.conditions_for_search(options)
    if user = User.find_by_token(options[:token])
      ['user_id IS NULL OR user_id = ?', user.id]
    else
      'user_id IS NULL'
    end
  end

  def self.options_for_search(options)
    { :page       => options[:page]     || 1,
      :per_page   => options[:per_page] || 50,
      :conditions => conditions_for_search(options),
      :order      => 'id ASC'
    }
  end
end
