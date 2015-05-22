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
    And `hosts.first.name` should be `"host1"`
    And `hosts.last.name` should be `"host2"`

  Scenario: read an inventory file with host variables
    Given an Ansible inventory file containing:
      """ini
      host1 ansible_ssh_user=ubuntu ansible_ssh_private_key_file=private_key.pem
      host2 ansible_ssh_user=ubuntu ansible_ssh_private_key_file=private_key.pem
      """
    When we read the Ansible inventory file using Ansible::Inventory.read_file
    And `hosts.first.name` should be `"host1"`
    And `hosts.first.vars['ansible_ssh_private_key_file']` should be `"private_key.pem"`
    And `hosts.last.vars['ansible_ssh_user']` should be `"ubuntu"`

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
    And the first group should have 1 host
    And `groups.first.hosts.first.name` should be `"host2"`
    And `groups.first.hosts.first.vars['ansible_ssh_user']` should be `"ubuntu"`

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
    And the first group should have 3 vars
    And `groups.first.vars.keys.first` should be `"mysql_root_password"`
    And `groups.first.vars['mysql_user_name']` should be `"mysql"`

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
    And `groups['databases'].children.count` should be 1
    And `groups['databases'].children.first` should be `"mysql"`
