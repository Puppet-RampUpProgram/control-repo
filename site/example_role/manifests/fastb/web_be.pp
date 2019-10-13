# This is an example of a product called
# "Fast B" 
# This is a web backend for that product.
class example_role::fastb::web_be {
  include profile::os::baseline
  include profile::app::fastb
}
