Feature: Inventory Writing
  In order to write Ansible inventory files

  Scenario: write an inventory file using Ansible::Inventory methods
    Given the following code snippet:
      """ruby
      inventory = Ansible::Inventory.new
      host = inventory.hosts.add 'host1', ansible_ssh_host: '172.31.3.134'
      mysql_group = inventory.groups.add 'mysql'
      mysql_group.hosts.add host
      mysql_group.hosts.add 'host2', ansible_ssh_host: '172.31.3.16'
      mysql_group.vars['mysql_root_password'] = 'secret'
      inventory.groups.add('databases').children << 'mysql'
      inventory.write_file('ansible_inventory')
      """
    Then the file "ansible_inventory" should contain:
      """ini
      host1 ansible_ssh_host=172.31.3.134

      [mysql]
      host1
      host2 ansible_ssh_host=172.31.3.16

      [mysql:vars]
      mysql_root_password=secret

      [databases:children]
      mysql
      """

  Scenario: prevent adding the same host twice, even with vars
    Given the following code snippet:
      """ruby
      @ansible_inventory = Ansible::Inventory.new
      @ansible_inventory.hosts.add 'host1', ansible_ssh_host: '172.31.3.134', ansible_ssh_user: 'ubuntu'
      @ansible_inventory.hosts.add 'host1', ansible_ssh_user: 'ubuntu', ansible_ssh_host: '172.31.3.134'
      """
    Then there should be 1 host

  Scenario: when removing a host from the global hosts, remove it from all groups
    Given the following code snippet:
      """ruby
      @ansible_inventory = Ansible::Inventory.new
      @ansible_inventory.hosts.add 'host1'
      @ansible_inventory.hosts.add 'host2'
      mysql_group = @ansible_inventory.groups.add 'mysql'
      mysql_group.hosts.add 'host1', ansible_ssh_user: 'ubuntu', ansible_ssh_host: '172.31.3.134'
      other_group = @ansible_inventory.groups.add 'other'
      other_group.hosts.add 'host1'
      other_group.hosts.add 'host2'
      @ansible_inventory.hosts.remove 'host1'
      """
    Then there should be 1 host
    And the "mysql" group should have 0 hosts
    And the "other" group should have 1 host
