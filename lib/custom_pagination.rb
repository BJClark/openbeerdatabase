module CustomPagination
  extend ActiveSupport::Concern

  included do
    def self.paginate_with_options(options = {})
      paginate_without_options(options_for_pagination(options))
    end

    class << self
      alias_method_chain :paginate, :options
    end

    def self.options_for_pagination(options)
      { :page       => options.delete(:page)     || 1,
        :per_page   => options.delete(:per_page) || 50,
        :conditions => conditions_for_pagination(options),
        :order      => order_for_pagination(options.delete(:order))
      }
    end

    def self.order_for_pagination(order)
      column, direction = order.to_s.split(" ", 2)

      column.to_s.downcase!
      column = "id" unless SORTABLE_COLUMNS.include?(column)

      direction.to_s.upcase!
      direction = "ASC" unless %w(ASC DESC).include?(direction)

      "#{column} #{direction}"
    end
  end
end
