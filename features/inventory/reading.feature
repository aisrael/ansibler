Feature: Inventory Reading
  In order to read Ansible inventory files

  Scenario: read a simple inventory file
    Given an Ansible inventory file containing:
      """ini
      # comments are ignored
      host1
      host2
      """
    When we read the Ansible inventory file using Ansible::Inventory.read_file
    Then there should be 2 hosts
    And the first host's name should be `"host1"`
    And the last host's name should be `"host2"`

  Scenario: read an inventory file with host variables
    Given an Ansible inventory file containing:
      """ini
      host1 ansible_ssh_user=ubuntu ansible_ssh_private_key_file=private_key.pem
      host2 ansible_ssh_user=ubuntu ansible_ssh_private_key_file=private_key.pem
      """
    When we read the Ansible inventory file using Ansible::Inventory.read_file
    And the first host's name should be `"host1"`
    And the "host1" host's `.vars['ansible_ssh_private_key_file']` should be `"private_key.pem"`
    And the "host2" host's `.vars['ansible_ssh_user']` should be `"ubuntu"`

  Scenario: read an inventory file with hosts and groups
    Given an Ansible inventory file containing:
      """ini
      host1
      host2 ansible_ssh_user=ubuntu ansible_ssh_private_key_file=private_key.pem

      [mysql]
      host2
      """
    When we read the Ansible inventory file using Ansible::Inventory.read_file
    Then there should be 1 group
    And the first group's name should be `"mysql"`
    And the "mysql" group should have 1 host
    And the "mysql" group's `.hosts.first.name` should be `"host2"`
    And the "mysql" group's `.hosts.first.vars['ansible_ssh_user']` should be `"ubuntu"`

  Scenario: read an inventory file with group variables
    Given an Ansible inventory file containing:
      """ini
      host1

      [mysql]
      host1

      [mysql:vars]
      mysql_root_password=secret
      mysql_user_name=mysql
      mysql_user_password=mysql
      """
    When we read the Ansible inventory file using Ansible::Inventory.read_file
    Then there should be 1 group
    And the first group's name should be `"mysql"`
    And the "mysql" group should have 3 vars
    And the "mysql" group's `.vars.keys.first` should be `"mysql_root_password"`
    And the "mysql" group's `.vars['mysql_user_name']` should be `"mysql"`

  Scenario: read an inventory file with group children
    Given an Ansible inventory file containing:
      """ini
      host1

      [mysql]
      host1

      [databases:children]
      mysql
      """
    When we read the Ansible inventory file using Ansible::Inventory.read_file
    Then there should be 2 groups
    And the first group's name should be `"mysql"`
    And the last group's name should be `"databases"`
    And the "databases" group should have 1 child
    And `groups['databases'].children.first` should be `"mysql"`
