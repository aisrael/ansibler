WORKING_DIR = File.join %w(tmp aruba)

Given /^an Ansible inventory file containing:$/ do |contents|
  step 'a file named "ansible_inventory" with:', contents
end

When(/^we read the Ansible inventory file using Ansible::Inventory\.read_file$/) do
  @ansible_inventory = Ansible::Inventory.read_file(File.join WORKING_DIR, 'ansible_inventory')
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

def in_dir(dir, &block)
  pwd = Dir.pwd
  begin
    Dir.chdir dir
    block.call
  ensure
    Dir.chdir pwd
  end
end

Given(/^the following code snippet:$/) do |snippet|
  in_dir WORKING_DIR do
    eval snippet
  end
end
