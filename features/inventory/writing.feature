Feature: Inventory Writing
  In order to write Ansible inventory files

  Scenario: write an inventory file using Ansible::Inventory methods
    Given the following code snippet:
      """
      inventory = Ansible::Inventory.new
      host = inventory.hosts.add 'host2', ansible_ssh_host: '172.31.3.134'
      mysql_group = inventory.groups.add 'mysql'
      mysql_group.hosts.add host
      mysql_group.vars['mysql_root_password'] = 'secret'
      inventory.groups.add('databases').children << 'mysql'
      inventory.write_file('ansible_inventory')
      """
    Then the file "ansible_inventory" should contain:
      """
      host2 ansible_ssh_host=172.31.3.134

      [mysql]
      host2

      [mysql:vars]
      mysql_root_password=secret

      [databases:children]
      mysql
      """
