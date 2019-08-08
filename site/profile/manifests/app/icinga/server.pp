# A description of what this class does
#
# @summary This class will install a icinga2 server
#
# @example
#   include profile::app::icinga::server
class profile::app::icinga::server (
  Boolean $manage_repo = false,
) {
  class { '::icinga2':
    manage_repo => $manage_repo,
  }
}
