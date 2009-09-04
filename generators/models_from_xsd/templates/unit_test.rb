require File.dirname(__FILE__) + '/../test_helper'

class <%= class_name %>Test < Test::Unit::TestCase
  fixtures <%= fixtures.join(",") %>

  def setup
    @<%= class_name.underscore.downcase %> = <%= class_name %>.new
  end
  
  def test_should_create_<%= class_name.underscore.downcase %>
    old_count = <%= class_name %>.count
    <%= class_name.underscore.downcase %> = new_<%= class_name.underscore.downcase %>
    assert <%= class_name.underscore.downcase %>.save, <%= class_name.underscore.downcase %>.errors.full_messages
    assert_equal old_count+1, <%= class_name %>.count  
  end

  def test_should_fail_with_empty_attributes
    assert !@<%= class_name.underscore.downcase %>.valid?
    assert_equal <%= required_attributes.size + belongs_to_assoc.size %>, @<%= class_name.underscore.downcase %>.errors.size, @<%= class_name.underscore.downcase %>.errors.full_messages
<%= belongs_to_assoc.collect {|a| "    assert @#{class_name.underscore.downcase}.errors.invalid?(:#{a}_id)\n"}.join -%>
<%= required_attributes.collect {|a| "    assert @#{class_name.underscore.downcase}.errors.invalid?(:#{has_many_assoc.include?(a.name) ? a.name.to_s.pluralize : a.name})\n"}.join -%>
  end
  
  protected

    def valid_<%= class_name.underscore.downcase %>_attributes
      {
<% attr_collection = belongs_to_assoc.collect {|assoc| "        :#{assoc}_id => 1"} -%>
<% attr_collection += required_attributes.select {|a| a.attributes.empty?}.collect {|attribute| "        :#{attribute.name} => #{attribute.default}"} -%>
<%= attr_collection.join(",\n") %>
      }
    end
  
    def new_<%= class_name.underscore.downcase %>(options = {})
      <%= class_name.underscore.downcase %> = <%= class_name %>.new(valid_<%= class_name.underscore.downcase %>_attributes.merge(options))
<% required_attributes.select {|a| !a.attributes.empty?}.each do |attribute| -%>
<% if has_many_assoc.include?(attribute.name) -%>
      <%= class_name.underscore.downcase %>.<%= attribute.name.to_s.pluralize %> << <%= attribute.name.to_s.pluralize %>(:one)
<% else -%>
      <%= class_name.underscore.downcase %>.<%= attribute.name %> = <%= attribute.name.to_s.pluralize %>(:one)
<% end -%>
<% end -%>
      <%= class_name.underscore.downcase %>
    end
end
