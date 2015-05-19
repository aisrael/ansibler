# ansibler

ansibler is a Ruby gem for reading and writing Ansible files.

## tl;dr

Given an `inventory_file` that contains:

```
ip-172-31-6-85
ip-172-31-3-134 ansible_ssh_host=172.31.3.134 ansible_ssh_user=ubuntu

[mysql]
ip-172-31-3-134
```

Then

```ruby
inventory = Ansible::Inventory.read_file('inventory_file')
inventory.hosts.count # => 2
inventory.hosts.first.name # => "ip-172-31-6-85"
inventory.hosts.last.vars.count # => 2
inventory.hosts.last.vars['ansible_ssh_host'] # => "172.31.3.134"
inventory.groups.count # => 1
inventory.groups.first.name # => "mysql"
inventory.groups.first.hosts.first.vars['ansible_ssh_user'] # => "ubuntu"
```

## Contributing to ansibler
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2015 Alistair A. Israel. See LICENSE.txt for
further details.
