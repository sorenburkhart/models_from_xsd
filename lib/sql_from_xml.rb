# Copyright (c) 2007 Soren Burkhart
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'rubygems'
require 'active_support'
require 'rexml/document'

class SqlFromXml
  
  attr_accessor :table_name, :row_id, :attributes, :parent
  
  @@table_ids = {}
  
  def self.table_ids
    @@table_ids
  end
  
  def initialize(table_name, row_id, parent)
    @table_name = table_name
    @row_id = row_id
    @attributes = {}
    @parent = parent
  end
  
  def self.build_from_xml(xml, parent = nil, &block)
    # Set block to class variable
    @@block ||= block
    
    # Load in XML File 
    xml = REXML::Document.new(File.new(xml).read).elements[1] if xml.class == String 
    
    # Table name that we are adding entries to singular form for now
    table_name = xml.name.underscore
    # Get next row_id for that table
    row_id =  (@@table_ids[table_name] = (@@table_ids[table_name] ||= 0) + 1) 
    # Create instance of entry
    current_entry = self.new(table_name, row_id, parent)
    
    # Gather the attribute values
    xml.elements.each do | ele |
      
      # A new table
      if ele.has_elements?
        self.build_from_xml(ele, current_entry)
      # An attribute
      else
        # Check for setting of reserved words in Active Record, and map accordingly
        reserved_words = %w(class, id, type)
        field = reserved_words.include?(ele.name.underscore) ? "attribute_"+ele.name.underscore : ele.name.underscore
        current_entry.attributes[field] = ele.text.gsub(/['"]/) { |m| '\\\\\\' + m } # Escape any single or double quotes
      end
    end
    
    # Build SQL Statement
    sql = "INSERT INTO #{current_entry.table_name.pluralize} ("
    sql += "id"
    sql += ", #{current_entry.parent.table_name}_id" unless current_entry.parent.nil?
    sql += ", " + current_entry.attributes.keys.join(", ") unless current_entry.attributes.empty?
    sql += ") VALUES ("
    sql += "#{current_entry.row_id}"
    sql += ", #{current_entry.parent.row_id}" unless current_entry.parent.nil?
    # Make sure all the values are quoted
    sql += ", " + current_entry.attributes.values.collect {|v| "'%s'" % v}.join(", ") unless current_entry.attributes.empty?
    sql += ");"
    
    # Output sql to block
    @@block.call(sql)
  end
end

