# General

When /^I send a GET request to (.*)$/ do |path|
  get path
end

When /^I send the following JSON via POST to (.*)$/ do |path, body|
  post path, body, { 'CONTENT_TYPE' => 'application/json' }
end

Then /^I should receive a (\d+) response$/ do |status|
  response.status.should == status
end

Then /^I should see the following JSON response$/ do |string|
  expected = JSON.parse(string)
  actual   = JSON.parse(response.body)
  actual.should == expected
end


# Beer

When /^I create the following beers? via the API using the "([^"]*)" token:$/ do |token, table|
  table.hashes.each do |hash|
    When %{I send the following JSON via POST to /api/v1/beers.json?token=#{token}}, { :beer => hash }.to_json
  end
end
