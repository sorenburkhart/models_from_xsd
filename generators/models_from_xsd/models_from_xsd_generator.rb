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

require 'model_from_xsd'

class ModelsFromXsdGenerator < Rails::Generator::NamedBase
  default_options :skip_migration => false

  def initialize(runtime_args, runtime_options = {})
    super
    
    # File that has the schema for the data tables
    xsd_file_path = @name   
    
    # File path that has the data to load
    @xml_file_path = args.shift || 'Enter file path of source file of data here before running migration.'
    
    puts "Loading models from XSD file #{@xsd_file_path}..."
    xml = File.new(xsd_file_path).read
    @model_from_xsd = ModelFromXSD.build_from_xsd(xml)
    puts "Loaded."
  end
  
  def manifest
    record do |m|
      if options[:generate_coredata]
        puts "Generate Objective C"
      else
        generate_model(m, @model_from_xsd)
        # Create final loader migration 
        unless options[:skip_migration]
          xsd_base_class = @model_from_xsd.name.to_s.pluralize.classify # Do the pluralize befores classify to eliminate incorrect class names due to plural form
          create_sql_commands = Array.new
          puts "Loading XML data to parse (this could take some time)..."
          SqlFromXml.build_from_xml(@xml_file_path) {|sql| create_sql_commands << '    execute ("' + sql + '")'}
          drop_sql_commands = Array.new
          SqlFromXml.table_ids.each {|key, value| drop_sql_commands << "    execute (\"DELETE FROM #{key.pluralize} WHERE id <= #{value};\")"}
          m.migration_template 'migration_loader_from_sql.rb', 'db/migrate',
                               :assigns => {:migration_name => "LoaderFor#{xsd_base_class}",
                                            :xsd_base_class => xsd_base_class,
                                            :xml_file_path => @xml_file_path,
                                            :create_sql_commands => create_sql_commands,
                                            :drop_sql_commands => drop_sql_commands
                                            },
                               :migration_file_name => "LoaderFor#{xsd_base_class}".underscore
        end
      end
    end
  end

  def generate_model(m, xsd_model)
    # Model class, unit test, and fixtures.
    m.template 'model.rb', File.join('app/models', "#{xsd_model.name}.rb"), 
               :assigns => {:class_name => xsd_model.name.to_s.pluralize.classify, 
                            :attribute_names => xsd_model.attributes.collect {|a|xsd_model.has_many.include?(a.name) ? a.name.to_s.pluralize.to_sym : a.name.to_sym} + xsd_model.belongs_to.collect {|a| "#{a}_id".to_sym},
                            :attributes_to_s => xsd_model.attributes.collect {|a|xsd_model.has_many.include?(a.name) ? a.name.to_s.pluralize.to_sym : a.name.to_sym},  
                            :attributes_to_hash => xsd_model.attributes,
                            :belongs_to_assoc => xsd_model.belongs_to, 
                            :has_one_assoc => xsd_model.has_one, 
                            :has_many_assoc => xsd_model.has_many,
                            :required_attributes => xsd_model.required_attributes
                           }
    m.template 'unit_test.rb',  File.join('test/unit', "#{xsd_model.name}_test.rb"), 
               :assigns => {:fixtures => ([xsd_model.name] + xsd_model.has_one + xsd_model.has_many).collect {|f| ":"+f.to_s.pluralize},
                            :class_name => xsd_model.name.to_s.pluralize.classify, 
                            :table_name => xsd_model.name.to_s.pluralize,
                            :belongs_to_assoc => xsd_model.belongs_to,
                            :has_many_assoc => xsd_model.has_many,
                            :required_attributes => xsd_model.required_attributes
                            }
    m.template 'fixtures.yml',  File.join('test/fixtures', "#{xsd_model.name.to_s.pluralize}.yml"), 
               :assigns => {:attributes => xsd_model.attributes.select {|a| a.attributes.empty?},
                            :belongs_to_assoc => xsd_model.belongs_to}
    unless options[:skip_migration]
      m.migration_template 'migration.rb', 'db/migrate', 
                           :assigns => {:skip_constraints => options[:skip_constraints],
                                        :migration_name => "Create#{xsd_model.name.to_s.pluralize.classify.pluralize}",
                                        :table_name => xsd_model.name.to_s.pluralize,
                                        :belongs_to_assoc => xsd_model.belongs_to,
                                        :attributes => xsd_model.attributes.select {|a| a.attributes.empty?}},    
                           :migration_file_name => "create_#{xsd_model.name.to_s.pluralize}"
    end
    xsd_model.attributes.each do |a|
      generate_model(m, a) unless a.attributes.empty?
    end
    
  end
  
  protected
    def banner
      "Usage: #{$0} models_from_xsd FILE_PATH_TO_XSD FILE_PATH_TO_XML"
    end

    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--skip-migration", 
             "Don't generate a migration file for this model") { |v| options[:skip_migration] = v }
      opt.on("--generate-coredata", 
             "Generate Objective C") { |v| options[:generate_coredata] = v }
    end
end