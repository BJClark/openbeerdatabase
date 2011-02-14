class Brewery < ActiveRecord::Base
  include CustomPagination

  SORTABLE_COLUMNS = %w(id name created_at updated_at).freeze

  has_many   :beers
  belongs_to :user

  validates :name, :presence => true, :length => { :maximum => 255 }
  validates :url,  :length   => { :maximum => 255 },
                   :format   => {
                     :with      => %r{\Ahttps?://((([\w_]+\.)*)?[\w_]+([-.][\w_]+)*\.[a-z]{2,6}\.?)([/?]\S*)?\Z}i,
                     :allow_nil => true
                   }

  attr_accessible :name, :url

  private

  def self.conditions_for_pagination(options)
    user = User.find_by_token(options[:token]) if options[:token].present?

    if user.present?
      ["user_id IS NULL OR user_id = ?", user.id]
    else
      "user_id IS NULL"
    end
  end
end
