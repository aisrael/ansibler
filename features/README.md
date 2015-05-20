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

## Use the source

https://github.com/aisrael/ansibler

## Copyright

Copyright (c) 2015 Alistair A. Israel. See LICENSE.txt for
further details.
