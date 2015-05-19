module Ansible

  class Inventory

    class << self
      def read_file(file)
        inventory = Inventory.new
        last_group = nil
        File.foreach(file) do |line|
          case
          when line =~ /^\[\S+\]$/
            group_name = line[/^\[(\S+)\]$/, 1]
            last_group = Group.new group_name
            inventory.groups << last_group
          when line =~ /^\s*[^\[]\S+\s*(\S+=\S+\s*)*$/
            host_name, *rest = line.split
            vars = Hash[rest.map {|s| s.split('=')}]
            host = Host.new host_name, vars
            if last_group
              last_group.hosts << host
            else
              inventory.hosts << host
            end

          end
        end
        inventory
      end
    end

    attr_reader :hosts
    attr_reader :groups

    def initialize
      @hosts = []
      @groups = []
    end

    class Host < Struct.new :name, :vars
      def initialize(*args)
        super
        self.vars = {} unless vars
      end
    end

    class Group < Struct.new :name, :hosts, :vars
      def initialize(*args)
        super
        self.hosts = [] unless hosts
        self.vars = {} unless vars
      end
    end
  end

end
