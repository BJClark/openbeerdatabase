module NavigationHelpers
  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      '/'

    when /^the API beer page for "([^"]+)"$/
      beer = Beer.find_by_name!($1)
      v1_beer_url(beer, :format => :json)
    when /^the API brewery page for "([^"]+)"$/
      brewery = Brewery.find_by_name!($1)
      v1_brewery_url(brewery, :format => :json)
    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
