Then /^I should see (?:the )(.*) element$/ do |named_element|
  page.should have_css(selector_for(named_element))
end
