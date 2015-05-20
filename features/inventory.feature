Feature: Inventory
  In order to read and write Ansible inventory files

  Scenario: read a simple inventory file
    Given an Ansible inventory file containing:
      """
      ip-172-31-6-85
      ip-172-31-3-134
      """
    When we read the Ansible inventory file using Ansible::Inventory.read_file
    Then `hosts.count` should be 2
    And `hosts.first.name` should be "ip-172-31-6-85"
    And `hosts.last.name` should be "ip-172-31-3-134"

  Scenario: read an inventory file with host variables
    Given an Ansible inventory file containing:
      """
      ip-172-31-6-85 ansible_ssh_host=172.31.6.85 ansible_ssh_user=ubuntu ansible_ssh_private_key_file=aws_private_key.pem
      ip-172-31-3-134 ansible_ssh_host=172.31.3.134 ansible_ssh_user=ubuntu ansible_ssh_private_key_file=aws_private_key.pem
      """
    When we read the Ansible inventory file using Ansible::Inventory.read_file
    And `hosts.first.name` should be "ip-172-31-6-85"
    And `hosts.first.vars['ansible_ssh_private_key_file']` should be "aws_private_key.pem"
    And `hosts.last.vars['ansible_ssh_user']` should be "ubuntu"

  Scenario: read an inventory file with hosts and groups
    Given an Ansible inventory file containing:
      """
      ip-172-31-6-85
      ip-172-31-3-134 ansible_ssh_host=172.31.3.134 ansible_ssh_user=ubuntu ansible_ssh_private_key_file=aws_private_key.pem

      [mysql]
      ip-172-31-3-134
      """
    When we read the Ansible inventory file using Ansible::Inventory.read_file
    Then `groups.count` should be 1
    And the first group's name should be "mysql"
    And the first group should have 1 host
    And `groups.first.hosts.first.name` should be "ip-172-31-3-134"
    And `groups.first.hosts.first.vars['ansible_ssh_user']` should be "ubuntu"

  Scenario: read an inventory file with group variables
    Given an Ansible inventory file containing:
      """
      ip-172-31-6-85

      [mysql]
      ip-172-31-6-85

      [mysql:vars]
      mysql_root_password=secret
      mysql_user_name=mysql
      mysql_user_password=mysql
      """
    When we read the Ansible inventory file using Ansible::Inventory.read_file
    Then `groups.count` should be 1
    And the first group's name should be "mysql"
    And the first group should have 3 vars
    And `groups.first.vars.keys.first` should be "mysql_root_password"
    And `groups.first.vars['mysql_user_name']` should be "mysql"

  Scenario: write an inventory file using Ansible::Inventory methods
    Given the following code snippet:
      """
      inventory = Ansible::Inventory.new
      host = inventory.hosts.add 'ip-172-31-3-134', ansible_ssh_host: '172.31.3.134'
      mysql_group = inventory.groups.add 'mysql'
      mysql_group.hosts.add host
      mysql_group.vars['mysql_root_password'] = 'secret'
      inventory.write_file('ansible_inventory')
      """
    Then the file "ansible_inventory" should contain:
      """
      ip-172-31-3-134 ansible_ssh_host=172.31.3.134

      [mysql]
      ip-172-31-3-134

      [mysql:vars]
      mysql_root_password=secret
      """
