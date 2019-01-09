# This is an example of a product called
# "Fast B" 
# This is a monitoring server for that product.
class role::sup_svc::monitor::server {
  include profile::os::base
  include profile::app::icinga
}
