# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include puppet_control_starter::profile::app::icinga
class profile::app::icinga {
  class { '::icinga2':
    manage_repo => false,
  }
}
