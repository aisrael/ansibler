require 'active_support/all'

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
          when line =~ /^\s*#/
            next
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
              k, v = host_name.split('=', 2)
              last_group.vars[k] = v
            else
              vars = ActiveSupport::HashWithIndifferentAccess[rest.map {|s| s.split('=', 2)}]
              if last_group
                host = inventory.hosts.find {|h| h.name == host_name} || Host.new(host_name, vars)
                last_group.hosts << host
              else
                inventory.hosts.add host_name, vars
              end
            end
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
          unless group.hosts.empty?
            f.puts
            f.puts "[#{group.name}]"
            group.hosts.each {|host|
              if hosts.find {|h| h == host }
                f.puts host.name
              else
                f.puts ([host.name] + host.vars.map {|k, v| "#{k}=#{v}"}).join(' ')
              end
            }
          end
          unless group.vars.empty?
            f.puts
            f.puts "[#{group.name}:vars]"
            group.vars.each {|k, v|
              f.puts "#{k}=#{v}"
            }
          end
          unless group.children.empty?
            f.puts
            f.puts "[#{group.name}:children]"
            group.children.each {|s| f.puts s}
          end
        }
      end
    end

    attr_reader :hosts
    attr_reader :groups

    def initialize
      @hosts = InventoryHostCollection.new(self)
      @groups = Group::Collection.new
    end

    class Host < Struct.new :name, :vars
      def initialize(name, hash = {})
        super(name)
        self.vars = ActiveSupport::HashWithIndifferentAccess.new(hash)
      end
      def ==(other)
        (name == other.name) && (vars == other.vars)
      end
      class Collection < Array
        def add(*args)
          host = if args.first.is_a?(Host)
            args.first
          else
            Host.new(*args)
          end
          # prevent dups
          if existing = self.find {|h| h == host}
            existing
          else
            self << host
            host
          end
        end
        def remove(host_or_name)
          host = if host_or_name.is_a?(Host)
            args.first
          elsif host_or_name.is_a?(String)
            self[host_or_name]
          end
          return unless host
          self.delete host
        end
        def [](name)
          find {|host| host.name == name}
        end
      end
    end

    class Group < Struct.new :name, :hosts, :vars, :children
      def initialize(*args)
        super
        self.hosts = Host::Collection.new unless hosts
        self.vars = ActiveSupport::HashWithIndifferentAccess.new(vars)
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

    def with_all_groups(&block)
      groups.each do |group|
        yield group
      end
    end

    private

    class InventoryHostCollection < Host::Collection
      def initialize(inventory)
        @inventory = inventory
      end
      def remove_with_globals(host_or_name)
        if host = remove_without_globals(host_or_name)
          @inventory.with_all_groups do |group|
            group.hosts.remove host.name
          end
        end
      end
      alias_method_chain :remove, :globals
    end

  end

end
