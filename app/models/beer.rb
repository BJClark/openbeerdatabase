class Beer < ActiveRecord::Base
  include CustomPagination

  SORTABLE_COLUMNS = %w(id name created_at updated_at).freeze

  belongs_to :brewery
  belongs_to :user

  validates :brewery_id,  :presence => true
  validates :name,        :presence => true, :length => { :maximum => 255 }
  validates :description, :presence => true, :length => { :maximum => 4096 }
  validates :abv,         :presence => true, :numericality => true

  attr_accessible :name, :description, :abv

  private

  def self.conditions_for_pagination(options)
    user = User.find_by_token(options[:token]) if options[:token].present?

    if user.present?
      ["beers.user_id IS NULL OR beers.user_id = ?", user.id]
    else
      "beers.user_id IS NULL"
    end
  end

  def self.options_for_pagination(options)
    { :page       => options[:page]     || 1,
      :per_page   => options[:per_page] || 50,
      :conditions => conditions_for_pagination(options),
      :order      => order_for_pagination(options[:order]),
      :include    => :brewery
    }
  end
end
