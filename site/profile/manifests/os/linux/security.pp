# This is a class example for security
class profile::os::linux::security (
  Boolean $pe_environment = true,
) {
  class { '::os_hardening':
    pe_environment => $pe_environment,
  }
}
