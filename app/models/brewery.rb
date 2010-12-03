class Brewery < ActiveRecord::Base
  has_many   :beers
  belongs_to :user

  validates :name, :presence => true, :length => { :maximum => 255 }
  validates :url,  :length   => { :maximum => 255 },
                   :format   => {
                      :with      => %r{\Ahttps?://((([^\W_]+\.)*)?[^\W_]+([-.][^\W_]+)*\.[a-z]{2,6}\.?)([/?]\S*)?\Z}iux,
                      :allow_nil => true
                    }

  attr_accessible :name, :url

  def self.paginate_with_options(options = {})
    paginate_without_options(options_for_pagination(options))
  end

  class << self
    alias_method_chain :paginate, :options
  end

  private

  def self.conditions_for_pagination(options)
    if user = User.find_by_token(options[:token])
      ['user_id IS NULL OR user_id = ?', user.id]
    else
      'user_id IS NULL'
    end
  end

  def self.options_for_pagination(options)
    { :page       => options[:page]     || 1,
      :per_page   => options[:per_page] || 50,
      :conditions => conditions_for_pagination(options),
      :order      => 'id ASC'
    }
  end
end
