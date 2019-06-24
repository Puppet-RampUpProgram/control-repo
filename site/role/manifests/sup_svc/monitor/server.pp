# This is a monitoring server for that many products and services
class role::sup_svc::monitor::server {
  include profile::os::baseline
  include profile::app::icinga::server
}
