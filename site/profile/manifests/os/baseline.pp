# This profile an example of base profile.
# It should support all site OS's and sould be enforced
# on all agent hosts.  This is the minimum bar of site
# specific hosts.
class profile::os::baseline (
  Array[String[1]] $name_servers = [ '8.8.8.8', '8.8.4.4' ],
  Array[String[1]] $search_path  = [ 'localdomain', 'puppet.vm' ],
) {
  # Profile to set a default base level of acceptable security and
  # configuration for systems to be used within the company networks.
  case $facts['os']['family'] {
    'RedHat','Debian': {
      class { 'profile::os::baseline::dns_resolver':
        name_servers => $name_servers,
        search_path  => $search_path,
      }
      include 'profile::os::linux::security'
    }
    'windows': {
      class { 'profile::os::baseline::dns_resolver':
        name_servers => $name_servers,
        search_path  => $search_path,
      }
      include profile::os::windows::security
    }
    'Solaris': {
      class { 'profile::os::baseline::dns_resolver':
        name_servers => $name_servers,
        search_path  => $search_path,
      }
      include profile::os::solaris::enable_ssh
    }
    default: {
      fail("OS family ${facts['os']['family']} is not supported with ${title}.")
    }
  }
  # Profile does the OS case statement 
  # Profile will normalize the 'temp' path for Linux, Solaris, and Windows
  include profile::os::baseline::archives
  # Profile does motd and banner
  include profile::os::baseline::banner
  # Profile validates trusted.extensions are set
  $extensions = lookup('profile::os::baseline::verify_trusted_data::extentions', Array,  'deep')
  class { 'profile::os::baseline::verify_trusted_data':
    extensions_to_check => $extensions,
  }
}
