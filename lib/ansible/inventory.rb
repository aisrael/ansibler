module Ansible

  class Inventory

    class << self
      def read_file(file)
        inventory = Inventory.new
        last_group = nil
        in_vars = false
        in_children = false
        File.foreach(file) do |line|
          case
          # [group:vars] or [group:chidren]
          when line =~ /^\[\S+:(vars|children)\]$/
            group_name, vars_or_children = line[/^\[(\S+)\]$/, 1].split(':')
            in_vars = vars_or_children == 'vars'
            in_children = vars_or_children == 'children'
            last_group = inventory.groups[group_name] || inventory.groups.add(group_name)
          # [group]
          when line =~ /^\[[^:]+\]$/
            group_name = line[/^\[(\S+)\]$/, 1]
            last_group = inventory.groups.add(group_name)
          when line =~ /^\s*[^\[]\S+\s*(\S+=\S+\s*)*$/
            host_name, *rest = line.split
            if in_children && rest.empty?
              child_group = inventory.groups[host_name] || inventory.groups.add(host_name)
              last_group.children << child_group.name
            elsif in_vars && host_name.index('=') && rest.empty?
              k, v = host_name.split('=')
              last_group.vars[k] = v
            else
              vars = Hash[rest.map {|s| s.split('=')}]
              if last_group
                host = inventory.hosts.find {|h| h.name == host_name} || Host.new(host_name, vars)
                last_group.hosts << host
              else
                inventory.hosts.add host_name, vars
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
          unless group.vars.empty?
            f.puts
            f.puts "[#{group.name}:vars]"
            group.vars.each {|k, v|
              f.puts "#{k}=#{v}"
            }
          end
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

    class Group < Struct.new :name, :hosts, :vars, :children
      def initialize(*args)
        super
        self.hosts = Host::Collection.new unless hosts
        self.vars = {} unless vars
        self.children = []
      end
      class Collection < Array
        def add(*args)
          self << group = Group.new(*args)
          group
        end
        def [](name)
          find {|group| group.name == name}
        end
      end
    end
  end

end
