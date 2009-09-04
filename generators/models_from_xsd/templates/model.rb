class <%= class_name %> < ActiveRecord::Base
<% for assoc in belongs_to_assoc -%>
  belongs_to <%= ":#{assoc}" %>
<% end -%>
<% for assoc in has_one_assoc -%>
  has_one <%= ":#{assoc}" %>, :dependent => :destroy
<% end -%>
<% for assoc in has_many_assoc -%>
  has_many <%= ":#{assoc.to_s.pluralize}" %>, :dependent => :destroy
<% end -%>
<% unless attribute_names.empty? -%>
  attr_accessible <%= attribute_names.collect {|a| ":#{a}"}.join(", ") %>
<% end -%>
<% unless required_attributes.empty? -%>
  # Checks for presence of required attributes
  validates_presence_of <%= required_attributes.collect {|a| has_many_assoc.include?(a.name) ? ":#{a.name.to_s.pluralize}" : ":#{a.name}" }.join(", ") %>
<% end -%>
<% unless belongs_to_assoc.empty? -%>
  # Checks for presence of foreign key
  validates_presence_of <%= belongs_to_assoc.collect {|a| ":#{a}_id"}.join(", ") %>
<% end -%>

  # Outputs all fields to string
  def to_s
    "<%= attributes_to_s.collect {|a| '#{' + a.to_s + '}'}.join(" ")%>"
  end
  
  # Outputs all fields as a hash
  def to_hash
    {<%= attributes_to_s.collect {|a| ":%s => %s" % 
                                        [a, (has_many_assoc + has_one_assoc).include?(a.to_s.singularize.to_sym) ? "%s.nil? ? %s : %s" % 
                                          ((has_many_assoc).include?(a.to_s.singularize.to_sym) ? [a, "[]", "#{a}.collect {|a| a.to_hash}"] : [a,  "{}", "#{a}.to_hash"]) : a]}.join(", ") %>}
  end
  
  # Create Unordered List from values
  def to_ul(nesting = 0)
    # Set order of attributes to display
    attribute_order = [<%= attribute_names.select {|a| (a.to_s=~/^.*_id$/).nil?}.collect {|a| ":#{a}"}.join(", ") %>]
    # Handle nesting of spaces during recursive calls
    spacing = "    "*nesting
    html = "\n" + spacing + "<ul>\n"  
    attribute_order.each do |a|
      html += spacing + "  <li>\n"
      html += spacing + "    <span class=\"label\">#{a}:</span>\n"
      html += spacing + "    <span class=\"value\">"
      # Ask object for attribute
      value = self.__send__(a.to_sym)
      # Check to do a recursive call to get the association
      # Check for has_many relationship
      if [<%= has_many_assoc.collect {|a| ":#{a}"}.join(", ") %>].include?(a.to_s.singularize.to_sym) 
        html += value.collect{|v| spacing + "  " +  v.to_ul(nesting+1)}.join unless value.nil?
      # Check for has_one relationship
      elsif [<%= has_one_assoc.collect {|a| ":#{a}"}.join(", ") %>].include?(a)
        html += spacing + "  " +  value.to_ul(nesting+1) unless value.nil?
      # Otherwise must be attribute value
      else
        html += spacing + "  " + value.to_s unless value.nil?
      end
      html += spacing + "</span>\n"
      html += spacing + "  </li>\n"
    end
    html += spacing + "</ul>\n"  
  end
end
