module ActiveModel
  class Errors
    def as_json(options = nil)
      keys.sort.inject({}) do |result, key|
        result[key] = self[key]
        result
      end
    end
  end
end
