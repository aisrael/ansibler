module Ansible

  class Inventory

    class << self
      def read_file(file)
        inventory = Inventory.new
        last_group = nil
        in_vars = false
        File.foreach(file) do |line|
          case
          when line =~ /^\[\S+\]$/
            group_name = line[/^\[(\S+)\]$/, 1]
            in_vars = group_name.end_with?(':vars')
            if in_vars
              actual_group_name = group_name[0, group_name.index(':')]
              last_group = inventory.groups.find { |g| g.name == actual_group_name }
              last_group ||= inventory.groups.add(actual_group_name)
            else
              last_group = Group.new group_name
              inventory.groups << last_group
            end
          when line =~ /^\s*[^\[]\S+\s*(\S+=\S+\s*)*$/
            host_name, *rest = line.split
            if in_vars && host_name.index('=') && rest.empty?
              k, v = host_name.split('=')
              last_group.vars[k] = v
            else
              vars = Hash[rest.map {|s| s.split('=')}]
              if last_group
                host = inventory.hosts.find {|h| h.name == host_name} || Host.new(host_name, vars)
                last_group.hosts << host
              else
                host = Host.new host_name, vars
                inventory.hosts << host
              end
            end
          else
            puts line
          end
        end
        inventory
      end
    end

    def write_file(file)
      File.open(file, 'w') do |f|
        hosts.each {|host|
          f.puts ([host.name] + host.vars.map {|k, v| "#{k}=#{v}"}).join(' ')
        }
        groups.each {|group|
          f.puts
          f.puts "[#{group.name}]"
          group.hosts.each {|host|
            if hosts.find {|h| h == host }
              f.puts host.name
            else
              f.puts ([host.name] + host.vars.map {|k, v| "#{k}=#{v}"}).join(' ')
            end
          }
        }
      end
    end

    attr_reader :hosts
    attr_reader :groups

    def initialize
      @hosts = Host::Collection.new
      @groups = Group::Collection.new
    end

    class Host < Struct.new :name, :vars
      def initialize(*args)
        super
        self.vars = {} unless vars
      end
      class Collection < Array
        def add(*args)
          host = if args.first.is_a?(Host)
            args.first
          else
            Host.new(*args)
          end
          self << host
          host
        end
      end
    end

    class Group < Struct.new :name, :hosts, :vars
      def initialize(*args)
        super
        self.hosts = Host::Collection.new unless hosts
        self.vars = {} unless vars
      end
      class Collection < Array
        def add(*args)
          self << group = Group.new(*args)
          group
        end
      end
    end
  end

end
