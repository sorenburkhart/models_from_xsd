require "rexml/document"

# This code was originally based off of an example from:
# Wayne Robinson
# http://www.wayne-robinson.com/journal/2006/5/1/ruby-on-rails-activerecordbuild_from_xml-function.html
#
# My enhancement allows multiple level of associations and nesting which was not possible before.
# Soren Burkhart http://www.hawaiibcllc.com

module ActiveRecord
  class Base
    def self.build_from_xml(xml)
      # Load in XML File 
      xml = REXML::Document.new(File.new(xml).read).elements[1] if xml.class == String 
      
      ar = self.new
      xml.elements.each do | ele |
        sym = ele.name.underscore.to_sym
        sym_plural = ele.name.underscore.pluralize.to_sym
        sym_attribute = ("attribute_"+ele.name.underscore).to_sym
        # An association
        if ele.has_elements?
          assoc = (self.reflect_on_association(sym) || self.reflect_on_association(sym_plural))
          klass = assoc.klass
          macro = assoc.macro

          case macro 
          when :has_one
            ar.__send__("#{sym}=", klass.build_from_xml(ele))
          else
            ar.__send__(sym_plural) << klass.build_from_xml(ele)
          end
        # An attribute
        else
          # Check for setting of reserved words in Active Record, and map accordingly
          reserved_words = [:class, :id, :type]
          sym = reserved_words.include?(sym) ? sym_attribute : sym
          ar[sym] = ele.text
        end
      end
      return ar
    end
  end
end

class <%= migration_name %> < ActiveRecord::Migration
  
  def self.up
    puts "Building records from xml file..."
    base = <%= xsd_base_class %>.build_from_xml("<%= xml_file_path %>")
    puts "Saving records...(This could take a while)"
    base.save!
    puts "Saved!"
  end

  def self.down
    <%= xsd_base_class %>.find(:all).each {|o| o.destroy}
  end
end
