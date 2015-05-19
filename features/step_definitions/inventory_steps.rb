Given /^an Ansible inventory file containing$/ do |body|
  @ansible_inventory_file = Tempfile.open('ansibler-') do |f|
    f.write body
    f
  end
end

When(/^we read the file using Ansible::Inventory\.read_file$/) do
  @ansible_inventory = Ansible::Inventory.read_file(@ansible_inventory_file.path)
end

Then(/^`(\S+)` should be (\d+)$/) do |something, value|
  # Yes, we use eval. It should be safe (do we need a test for that?)
  actual = eval("@ansible_inventory.#{something}").to_i
  expected = value.to_i
  expect(actual).to eq(expected)
end

Then(/^`(\S+)` should be "(\S+)"$/) do |something, expected|
  # Yes, eval.
  actual = eval("@ansible_inventory.#{something}")
  expect(actual).to eq(expected)
end

Then(/^the (first|last) (\S+)'s (\S+) should be "([^"]*)"$/) do |first_or_last, collection, attribute, expected|
  steps %Q{
    Then `#{collection}s.#{first_or_last}.#{attribute}` should be \"#{expected}\"
  }
end

Then(/^the (first|last) (\S+) should have (\d+) (\S+)$/) do |first_or_last, collection, n, sub_collection|
  steps %Q{
    Then `#{collection}s.#{first_or_last}.#{sub_collection}s.count` should be #{n}
  }
end