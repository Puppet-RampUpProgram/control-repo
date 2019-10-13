# This is a role to add to the Puppet Master.
class example_role::sup_svc::puppet::master {
  include profile::os::baseline
  include profile::app::puppet::masters
}
