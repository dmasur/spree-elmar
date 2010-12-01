class Admin::ElmarsController < Spree::BaseController
  resource_controller :singleton
  def create_shop_xml
    xml = Elmar.create_shop_xml
    redirect_to admin_elmar_path
  end
end