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

class ModelFromXSD
  attr_accessor :name, :min_occurs, :max_occurs, :data_type, :has_one, :has_many, :belongs_to, :attributes, :default
  
  def initialize(name, min_occurs, max_occurs, data_type = nil)
    reserved_words = [:class, :type, :id]
    # This is to deal with the case when the name of an attribute is a reserverd word and messes up Active Record, 
    # we don't worry about creating classes with these words because they are in plural form
    @name = data_type && reserved_words.include?(name) ? ("attribute_" + name.to_s).to_sym : name  
    @data_type = data_type
    @min_occurs = min_occurs 
    @max_occurs = max_occurs  
    @has_many = []
    @has_one = []
    @belongs_to = []
    @attributes = []
  end
  
  # Used for generating fixtures
  def default
    case data_type
    when /.*:string/: "'Sample #{name} here'"
    when /.*:int/: 1
    when /.*:boolean/: true
    else "'#{data_type}'"
    end
  end
  
  def self.build_from_xsd(xml, m = nil)
    xml = REXML::Document.new(xml) if xml.class == String
    xml.elements.each do | ele |
      sym = ele.name.underscore.to_sym
      #puts "Inside #{ele.name}"
      case ele.name.underscore.to_sym
      
      when :element
        #puts "Element #{ele.attributes["name"].underscore.to_sym}"
        current_m = self.new(ele.attributes["name"].underscore.to_sym,
                             ele.attributes["minOccurs"],
                             ele.attributes["maxOccurs"])
        if ele.has_elements? 
          # Model
          if m.nil?
            m = self.build_from_xsd(ele, current_m)
          else
            m.add_model(self.build_from_xsd(ele, current_m))
          end
        else
          # Attribute
          if m.nil?
            m = current_m
          else
            m.attributes << self.new(ele.attributes["name"].underscore.to_sym,
                                     ele.attributes["minOccurs"],
                                     ele.attributes["maxOccurs"],
                                     ele.attributes["type"])
          end
        end
      else
        return self.build_from_xsd(ele, m)
      end
    end
    
    return m
  end
  
  def add_model(m)
    # Add atributes
    attributes << m
    
    # Determine Relationship
    case     
    when m.max_occurs == "unbounded" || m.max_occurs.to_i > 1
      self.has_many << m.name
    when m.max_occurs.to_i == 1
      self.has_one << m.name
    else
      raise "Error cannot have max_occurs be #{m.max_occurs} for Model #{m.name}"
    end
    
    m.belongs_to << self.name
  end
  
  # Is this field required
  def required?
    min_occurs.nil? || min_occurs.to_i >= 1
  end
  
  # Make sure it is an attribute of the class (including foreign keys)
  def attribute?(a)
    !(self.has_one + self.belongs_to).include?(a.name.to_sym) && !(self.has_many).include?(a.name.to_s.pluralize.to_sym)
  end  
  
  # Return the attributes that are required to create a class
  def required_attributes
    self.attributes.select {|a| a.required?}
  end
  
end
