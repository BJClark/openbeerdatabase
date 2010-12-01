class Hash
  def to_jsonp(callback = nil)
    if callback.present?
      "#{callback}(#{self.to_json});"
    else
      self.to_json
    end
  end
end
