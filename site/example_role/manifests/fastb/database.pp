# This is an example of a product called
# "Fast B" 
# This is a database for that product.
class example_role::fastb::database {
  include profile::os::baseline
  include profile::app::mysql::server
}
