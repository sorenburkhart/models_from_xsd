require "test/unit"
require "model_from_xsd"

class SdnModelsFromXsdTest < Test::Unit::TestCase

  def test_build_from_sdn
    xsd_model = ModelFromXSD.build_from_xsd(File.new(File.dirname(__FILE__) +"/SDN.XSD").read)

    sdn_list = hash_model(:sdn_list, nil, nil, [:publsh_information], [:sdn_entry])

    publsh_information = hash_model(:publsh_information, nil, 1, [], [], [:sdn_list])
    publsh_information[:attributes] << hash_attribute(:publish_date, :string, 0, 1)
    publsh_information[:attributes] << hash_attribute(:record_count, :int, 0, 1)

    sdn_list[:attributes] << publsh_information

    sdn_entry = hash_model(:sdn_entry, nil, "unbounded", [:program_list, :id_list, :aka_list, :address_list, :nationality_list, :citizenship_list, :date_of_birth_list, :place_of_birth_list, :vessel_info], [], [:sdn_list])
    sdn_entry[:attributes] << hash_attribute(:uid, :int)
    sdn_entry[:attributes] << hash_attribute(:first_name, :string, 0)
    sdn_entry[:attributes] << hash_attribute(:last_name, :string)
    sdn_entry[:attributes] << hash_attribute(:title, :string, 0)
    sdn_entry[:attributes] << hash_attribute(:sdn_type, :string)
    sdn_entry[:attributes] << hash_attribute(:remarks, :string, 0)

    program_list = hash_model(:program_list, 1, 1, [], [], [:sdn_entry])
    program_list[:attributes] << hash_attribute(:program, :string, 0, "unbounded")

    sdn_entry[:attributes] << program_list

    id_list = hash_model(:id_list, 0, 1, [], [:id], [:sdn_entry])

    id = hash_model(:id, 0, "unbounded", [], [], [:id_list])
    id[:attributes] << hash_attribute(:uid, :int)
    id[:attributes] << hash_attribute(:id_type, :string, 0)
    id[:attributes] << hash_attribute(:id_number, :string, 0)
    id[:attributes] << hash_attribute(:id_country, :string, 0)
    id[:attributes] << hash_attribute(:issue_date, :string, 0)
    id[:attributes] << hash_attribute(:expiration_date, :string, 0)
    
    id_list[:attributes] << id

    sdn_entry[:attributes] << id_list
    
    aka_list = hash_model(:aka_list, 0, 1, [], [:aka], [:sdn_entry])
    
    aka = hash_model(:aka, 0, "unbounded", [], [], [:aka_list])
    aka[:attributes] << hash_attribute(:uid, :int)
    # Note this checks for the conversion of the XML from type to attribute_type
    aka[:attributes] << hash_attribute(:attribute_type, :string) 
    aka[:attributes] << hash_attribute(:category, :string)
    aka[:attributes] << hash_attribute(:last_name, :string, 0)
    aka[:attributes] << hash_attribute(:first_name, :string, 0)
    
    aka_list[:attributes] << aka
    
    sdn_entry[:attributes] << aka_list
    
    address_list = hash_model(:address_list, 0, 1, [], [:address], [:sdn_entry])
    
    address = hash_model(:address, 0, "unbounded", [], [], [:address_list])
    address[:attributes] << hash_attribute(:uid, :int)
    address[:attributes] << hash_attribute(:address1, :string, 0)
    address[:attributes] << hash_attribute(:address2, :string, 0)
    address[:attributes] << hash_attribute(:address3, :string, 0)
    address[:attributes] << hash_attribute(:city, :string, 0)
    address[:attributes] << hash_attribute(:state_or_province, :string, 0)
    address[:attributes] << hash_attribute(:postal_code, :string, 0)
    address[:attributes] << hash_attribute(:country, :string, 0)
    
    address_list[:attributes] << address
    
    sdn_entry[:attributes] << address_list
    
    nationality_list = hash_model(:nationality_list, 0, 1, [], [:nationality], [:sdn_entry])
    
    nationality = hash_model(:nationality, 0, "unbounded", [], [], [:nationality_list])
    nationality[:attributes] << hash_attribute(:uid, :int)
    nationality[:attributes] << hash_attribute(:country, :string)
    nationality[:attributes] << hash_attribute(:main_entry, :boolean)
    
    nationality_list[:attributes] << nationality
    
    sdn_entry[:attributes] << nationality_list
    
    citizenship_list = hash_model(:citizenship_list, 0, 1, [], [:citizenship], [:sdn_entry])
    
    citizenship = hash_model(:citizenship, 0, "unbounded", [], [], [:citizenship_list])
    
    citizenship[:attributes] << hash_attribute(:uid, :int)
    citizenship[:attributes] << hash_attribute(:country, :string)
    citizenship[:attributes] << hash_attribute(:main_entry, :boolean)
    
    citizenship_list[:attributes] << citizenship
    
    sdn_entry[:attributes] << citizenship_list
    
    date_of_birth_list = hash_model(:date_of_birth_list, 0, 1, [], [:date_of_birth_item], [:sdn_entry])
        
    date_of_birth_item = hash_model(:date_of_birth_item, 0, "unbounded", [], [], [:date_of_birth_list])
    date_of_birth_item[:attributes] << hash_attribute(:uid, :int)
    date_of_birth_item[:attributes] << hash_attribute(:date_of_birth, :string)
    date_of_birth_item[:attributes] << hash_attribute(:main_entry, :boolean)
        
    date_of_birth_list[:attributes] << date_of_birth_item
    
    sdn_entry[:attributes] << date_of_birth_list
    
    place_of_birth_list = hash_model(:place_of_birth_list, 0, 1, [], [:place_of_birth_item], [:sdn_entry])
        
    place_of_birth_item = hash_model(:place_of_birth_item, 0, "unbounded", [], [], [:place_of_birth_list])
        
    place_of_birth_item[:attributes] << hash_attribute(:uid, :int)
    place_of_birth_item[:attributes] << hash_attribute(:place_of_birth, :string)
    place_of_birth_item[:attributes] << hash_attribute(:main_entry, :boolean)
        
    place_of_birth_list[:attributes] << place_of_birth_item
        
    sdn_entry[:attributes] << place_of_birth_list
    
    vessel_info = hash_model(:vessel_info, 0, 1, [], [], [:sdn_entry])
    vessel_info[:attributes] << hash_attribute(:call_sign, :string, 0)
    vessel_info[:attributes] << hash_attribute(:vessel_type, :string, 0)
    vessel_info[:attributes] << hash_attribute(:vessel_flag, :string, 0)
    vessel_info[:attributes] << hash_attribute(:vessel_owner, :string, 0)
    vessel_info[:attributes] << hash_attribute(:tonnage, :int, 0)
    vessel_info[:attributes] << hash_attribute(:gross_registered_tonnage, :int, 0)
        
    sdn_entry[:attributes] << vessel_info
         
    sdn_list[:attributes] << sdn_entry

    assert_xsd_model sdn_list, xsd_model

  end
  
  def assert_xsd_model(element, xsd_model)
    assert_equal element[:name], xsd_model.name
    assert_equal element[:data_type].to_s, xsd_model.data_type.to_s
    assert_equal element[:min_occurs], xsd_model.min_occurs
    assert_equal element[:max_occurs], xsd_model.max_occurs
    assert_equal element[:has_one], xsd_model.has_one
    assert_equal element[:has_many], xsd_model.has_many
    assert_equal element[:belongs_to], xsd_model.belongs_to      
    element[:attributes].each_with_index do |attribute, attribute_index|
      a = xsd_model.attributes[attribute_index]
      if attribute[:attributes].empty?
        # It is only an attribute
        assert_equal attribute[:name], a.name
        assert_equal attribute[:min_occurs], a.min_occurs
        assert_equal attribute[:max_occurs], a.max_occurs
        assert_equal attribute[:data_type].to_s, a.data_type.to_s
      else
        # It is a nested model
        assert_xsd_model(attribute, a)
      end
    end 
  end
  
  # Same hash structure as model, but increases readability
  def hash_attribute(name, data_type = nil, min_occurs = nil, max_occurs = nil, has_one = [], has_many = [], belongs_to = [], attributes =[])
    hash = {}
    hash[:name] = name
    hash[:data_type] = data_type ? "xs:" + data_type.to_s : nil
    hash[:min_occurs] = min_occurs ? min_occurs.to_s : nil
    hash[:max_occurs] = max_occurs ? max_occurs.to_s : nil
    hash[:has_one] = has_one
    hash[:has_many] = has_many
    hash[:belongs_to] = belongs_to
    hash[:attributes] = attributes

    hash
  end
  
  def hash_model(name, min_occurs, max_occurs, has_one = [], has_many = [], belongs_to = [], attributes =[])
    hash = {}
    hash[:name] = name
    hash[:data_type] = nil
    hash[:min_occurs] = min_occurs ? min_occurs.to_s : nil
    hash[:max_occurs] = max_occurs ? max_occurs.to_s : nil
    hash[:has_one] = has_one
    hash[:has_many] = has_many
    hash[:belongs_to] = belongs_to
    hash[:attributes] = attributes

    hash
  end

end