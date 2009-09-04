require "rexml/document"
class <%= migration_name %> < ActiveRecord::Migration
  
  def self.up
    puts "Building sql file from xml file..."
<%= create_sql_commands.join("\n") %>
    puts "Created"
  end

  def self.down
<%= drop_sql_commands.join("\n") %>
  end
end
