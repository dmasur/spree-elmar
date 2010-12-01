require "rexml/document"
# TODO: http://elektronischer-markt.de/nav?dest=impl.shopdata.examples.extended&rid=16
class Elmar
  def initialize options = {}
    merge_options options
  end
  def merge_options options = {}
    @shop_name = options[:shop_name] || @shop_name
    @url = options[:url] || @url
    @processor = options[:processor] || @processor
    @param_product = options[:param_product] || @param_product
    @name = options[:name] || @name
    @mapping = options[:mapping] || @mapping
    @csv_url = options[:csv_url] || @csv_url
    @mappings = { 1 => {:type=> 'privateid', :column_name => 'privateid'},
                  2 => {:type => 'name', :column_name => 'name'},
                  3 => {:type => 'brand', :column_name => 'brand'},
                  4 => {:type => 'ean', :column_name => 'ean'},
                  5 => {:type => 'deliverable', :column_name => 'deliverable'},
                  6 => {:type => 'deliverydetails', :column_name => 'deliverydetails'},
                  7 => {:type => 'longdescription', :column_name => 'longdescription'},
                  8 => {:type => 'pictureurl', :column_name => 'pictureurl'},
                  9 => {:type => 'price', :column_name => 'price'},
                  10 => {:type => 'longdescription', :column_name => 'longdescription'},
                  11 => {:type => 'unit', :column_name => 'unit'},
                  12 => {:type => 'specialdiscount', :column_name => 'specialdiscount'},
                  13 => {:type => 'type', :column_name => 'type'},
                  14 => {:type => 'url', :column_name => 'url'}}
    @csv_special_character_delimiter = ";"
    @csv_special_character_escaped = "\\"
    @csv_special_character_quoted = "'"
    @with_offline_request = options[:with_offline_request] || @with_offline_request || false
    @logo = options[:logo] || ""
  end
  def create_shop_xml
    doc = REXML::Document.new
    doc << REXML::XMLDecl.new(1.0, "ISO-8859-1")
    osp = doc.add_element(REXML::Element.new("osp:Shop"))
      osp.attributes["xmlns:osp"] = "http://elektronischer-markt.de/schema"
      osp.attributes["xmlns:xsi"] = "http://www.w3.org/2001/XMLSchema-instance"
      osp.attributes["xsi:schemaLocation"] = "http://elektronischer-markt.de/schema http://kuhlins.de/elmar/schema/shop.xsd"
      common = osp.add_element(REXML::Element.new("Common"))
        common.add_element(REXML::Element.new("Version").add_text REXML::Text.new('1.1'))
        common.add_element(REXML::Element.new("Language").add_text REXML::Text.new('de'))
        common.add_element(REXML::Element.new("Currency").add_text REXML::Text.new('EUR'))
    osp.add_element(REXML::Element.new("Name").add_text REXML::Text.new(@shop_name))
    osp.add_element(REXML::Element.new("Url").add_text REXML::Text.new(@url))
    requests = osp.add_element(REXML::Element.new("Requests"))
    online_request = requests.add_element(REXML::Element.new("OnlineRequest"))
    online_request.add_element(REXML::Element.new("Processor").add_text REXML::Text.new(@processor))
    online_request.add_element(REXML::Element.new("ParamProduct").add_text REXML::Text.new(@param_product))
    if @with_offline_request
      offline_request = requests.add_element(REXML::Element.new("OfflineRequest"))
      update_methods = offline_request.add_element(REXML::Element.new("UpdateMethods"))
      direct_download = update_methods.add_element(REXML::Element.new("DirectDownload"))
      direct_download.attributes["day"]="daily"
      format = offline_request.add_element(REXML::Element.new("Format"))
      tabular = format.add_element(REXML::Element.new("Tabular"))
      csv = tabular.add_element(REXML::Element.new("CSV"))
      csv.add_element(REXML::Element.new("Url").add_text REXML::Text.new(@csv_url))
      mappings = []
      @mappings.size.times{|x| mappings << "'"+@mappings[x+1][:column_name]+"'"}
      mappings = mappings.join(";")
      header = csv.add_element(REXML::Element.new("Header").add_text(REXML::Text.new(mappings)))
      header.attributes["columns"] = @mappings.size
      special_characters = csv.add_element(REXML::Element.new("SpecialCharacters"))
      special_characters.add_attributes({"delimiter"=> @csv_special_character_delimiter, 
        "escaped" => @csv_special_character_escaped, 
        "quoted" => @csv_special_character_quoted})
      mappings = tabular.add_element(REXML::Element.new("Mappings"))
      @mappings.each do |index, hash|
        mapping = mappings.add_element(REXML::Element.new("Mapping"))
        mapping.add_attributes({"column"=> index, 
          "columnName" => hash[:column_name], 
          "type" => hash[:type]})
      end
    end
    osp.add_element(REXML::Element.new("Logo").add_text(REXML::Text.new(@logo)))
    categories = osp.add_element(REXML::Element.new("Categories"))
    item = categories.add_element(REXML::Element.new("Item"))
    item.add_element(REXML::Element.new("Name").add_text REXML::Text.new(@name))
    item.add_element(REXML::Element.new("Mapping").add_text REXML::Text.new(@mapping))
    return doc
  end
end