module NamedElementHelper
  def selector_for(named_element)
    case named_element
    when /^the API token request form$/
      "form[method='post'][action='http://openbeerdatabase.createsend.com/t/r/s/ndyukh/']"

    else
      raise "Can't find mapping for \"#{named_element}\"."
    end
  end
end

World(NamedElementHelper)
