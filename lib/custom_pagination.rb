module CustomPagination
  extend ActiveSupport::Concern

  included do
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
