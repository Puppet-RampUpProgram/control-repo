# This is an example of a product called
# "Fast B" 
# This is a web backend for that product.
class role::fastb::web_be {
  include profile::os::base
  include profile::app::fastb
}
