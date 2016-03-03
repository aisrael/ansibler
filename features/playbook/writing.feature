Feature: Playbok Writing
  In order to write an Ansible playbook

  Scenario: write a playbook using methods
    Given the following code snippet:
      """ruby
      playbook = Ansible::Playbook.new
      playbook.hosts << 'all'
      playbook.tasks.add 'apt', update: true, pkg: 'mysql'
      playbook.write_file("site.yml")
      """
    Then the file "site.yml" should contain:
      """
      ---
      - hosts: all
        tasks:
        - apt pkg=mysql update=True
      """

  Scenario: write a playbook using the DSL
    Given the following code snippet:
      """ruby
      Ansible::Playbook.new {
        hosts 'all' {
          tasks {
            apt update: true, pkg: 'mysql'
          }
        }
      }.write_file("site.yml")
      """
    Then the file "site.yml" should contain:
      """
      ---
      - hosts: all
        tasks:
        - apt pkg=mysql update=True
      """
