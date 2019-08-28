# This is an example of a product called
# "Fast B" 
# This is a web backend for that product.
class example_role::spider::web_be {
  include profile::os::baseline
  include profile::app::iis::default_app_pool
  #  include profile::app::spider
}
