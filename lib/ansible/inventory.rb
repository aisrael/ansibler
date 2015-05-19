module Ansible

  class Inventory

    class << self
      def read_file(file)
        puts "Ansibler::Inventory.read_file(\"#{file}\")"
        inventory = Inventory.new
        File.foreach(file) do |line|
          case
          when line =~ /^\s*\S+\s+(\S+=\S+\s*)*$/
            host_name, *rest = line.split
            vars = Hash[rest.map {|s| s.split('=')}]
            host = Host.new host_name, vars
            inventory.hosts << host
          end
        end
        inventory
      end
    end

    attr_reader :hosts

    def initialize
      @hosts = []
    end

    class Host < Struct.new :name, :vars
    end
  end

end
