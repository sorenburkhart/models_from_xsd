require "test/unit"
require "sql_from_xml"

class SdnSqlFromXmlTest < Test::Unit::TestCase

  def test_build_sqn_sql
    input_xml_file = File.dirname(__FILE__) + "/sdn_small.xml"
    output_sql_file = File.dirname(__FILE__) + "/sdn_small.sql"
    master_sql_file = File.dirname(__FILE__) + "/master_sdn_small.sql"
    
    File.open(output_sql_file,"w") do |file|
      SqlFromXml.build_from_xml(input_xml_file) {|sql| puts sql; file << sql << "\n"}
    end
    assert files_match?(output_sql_file, master_sql_file), "Output sql did not match what was expected."
  end

  protected
    def files_match?(file1, file2)
      file1_text = ""
      file2_text = ""
      File.open(file1) {|f| f.each_line {|line| file1_text += line}}
      File.open(file2) {|f| f.each_line {|line| file2_text += line}}
      file1_text == file2_text
    end
end

