require File.dirname(__FILE__) + '/../spec_helper'

describe Elmar do
  before(:each) do
    @elmar = Elmar.new :shop_name => "Test Shop",
      :url => "http://www.testshop.de/",
      :processor => "http://www.testshop.de/servlets/search",
      :param_product => "product",
      :name => "Buecher",
      :mapping => "Buecher",
      :csv_url => "http://www.testshop.de/Preisliste.csv",
      :with_offline_request => false
  end

  it "should give simple shop_xml" do
    @elmar.merge_options({:with_offline_request => false})
    xml = @elmar.create_shop_xml.to_s
    xml.should include '<?xml version=\'1.0\' encoding=\'ISO-8859-1\'?>'
    xml.should include "<osp:Shop xmlns:osp='http://elektronischer-markt.de/schema'"
    xml.should include "xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance"
    xml.should include "xsi:schemaLocation='http://elektronischer-markt.de/schema http://kuhlins.de/elmar/schema/shop.xsd'"
    xml.should include "<Common>"
    xml.should include "<Version>1.1</Version>"
    xml.should include "<Language>de</Language>"
    xml.should include "<Currency>EUR</Currency>"
    xml.should include "</Common>"
    xml.should include "<Name>Test Shop</Name>"
    xml.should include "<Url>http://www.testshop.de/</Url>"
    xml.should include "<Requests>"
    xml.should include "<OnlineRequest>"
    xml.should include "<Processor>http://www.testshop.de/servlets/search</Processor>"
    xml.should include "<ParamProduct>product</ParamProduct>"
    xml.should include "</OnlineRequest>"
    xml.should include "</Requests>"
    xml.should include "<Categories>"
    xml.should include "<Item>"
    xml.should include "<Name>Buecher</Name>"
    xml.should include "<Mapping>Buecher</Mapping>"
    xml.should include "</Item>"
    xml.should include "</Categories>"
    xml.should include "</osp:Shop>"
  end
  it "should work with offline request" do
    @elmar.merge_options({:with_offline_request => true})
    xml = @elmar.create_shop_xml.to_s
    xml.should include "<OfflineRequest>"
    xml.should include "<UpdateMethods>"
    xml.should include "<DirectDownload day='daily'/>"
    xml.should include "</UpdateMethods>"
    xml.should include "<Format>"
    xml.should include "<Tabular>"
    xml.should include "<CSV>"
    xml.should include "<Url>http://www.testshop.de/Preisliste.csv</Url>"
    xml.should include "<Header columns='14'>&apos;privateid&apos;;&apos;name&apos;;&apos;brand&apos;;&apos;ean&apos;;&apos;deliverable&apos;;&apos;deliverydetails&apos;;&apos;longdescription&apos;;&apos;pictureurl&apos;;&apos;price&apos;;&apos;longdescription&apos;;&apos;unit&apos;;&apos;specialdiscount&apos;;&apos;type&apos;;&apos;url&apos;</Header>"
    xml.should include "<SpecialCharacters escaped='\\' quoted='&apos;' delimiter=';'/>"
    xml.should include "</CSV>"
    xml.should include "<Mappings>"
    xml.should include "<Mapping column='1' columnName='privateid' type='privateid'/>"
    xml.should include "<Mapping column='2' columnName='name' type='name'/>"
    xml.should include "<Mapping column='3' columnName='brand' type='brand'/>"
    xml.should include "<Mapping column='4' columnName='ean' type='ean'/>"
    xml.should include "<Mapping column='5' columnName='deliverable' type='deliverable'/>"
    xml.should include "<Mapping column='6' columnName='deliverydetails' type='deliverydetails'/>"
    xml.should include "<Mapping column='7' columnName='longdescription' type='longdescription'/>"
    xml.should include "<Mapping column='8' columnName='pictureurl' type='pictureurl'/>"
    xml.should include "<Mapping column='9' columnName='price' type='price'/>"
    xml.should include "<Mapping column='10' columnName='longdescription' type='longdescription'/>"
    xml.should include "<Mapping column='11' columnName='unit' type='unit'/>"
    xml.should include "<Mapping column='12' columnName='specialdiscount' type='specialdiscount'/>"
    xml.should include "<Mapping column='13' columnName='type' type='type'/>"
    xml.should include "<Mapping column='14' columnName='url' type='url'/>"
    xml.should include "</Mappings>"
    xml.should include "</Tabular>"
    xml.should include "</Format>"
    xml.should include "</OfflineRequest>"
  end
  it "should work with complex layout" do
    @elmar.merge_options({:logo =>"http://www.testshop.de/images/logo.gif"})
    xml = @elmar.create_shop_xml.to_s
    xml.should include "<Logo>http://www.testshop.de/images/logo.gif</Logo>"
  end
end
