class SpreeElmarHooks < Spree::ThemeSupport::HookListener
  insert_after :admin_configurations_menu, 'after_admin_configurations_menu'
end