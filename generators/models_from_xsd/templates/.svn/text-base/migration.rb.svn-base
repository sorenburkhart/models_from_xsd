class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
    # Add attributes for class from XSD file.  
<% for assoc in belongs_to_assoc -%>
      t.column :<%= assoc %>_id, :int, :null => false  
<% end -%>
<% for attribute in attributes -%>
      t.column :<%= attribute.name %>, :<%= attribute.data_type.gsub('xs:','') %><%= attribute.required? ? ", :null => false" : "" %>
<% end -%>
    end


  end

  def self.down
    drop_table :<%= table_name %>
  end
end
