# This profile an example of base profile.
# It should support all site OS's and sould be enforced
# on all agent hosts.  This is the minimum bar of site
# specific hosts.
class profile::os::base (
  Array[String[1]] $name_servers = [ '8.8.8.8', '8.8.4.4' ],
  Array[String[1]] $search_path  = [ 'localdomain', 'puppet.vm' ],
) {
  # Profile to set a default base level of acceptable security and
  # configuration for systems to be used within the company networks.
  case $facts['os']['family'] {
    'RedHat': {
      class { 'profile::os::dns_resolver':
        name_servers => $name_servers,
        search_path  => $search_path,
      }
      #include 'profile::os::linux::security'
    }
    'windows': {
      class { 'profile::os::dns_resolver':
        name_servers => $name_servers,
        search_path  => $search_path,
      }
      #include profile::os::windows::security
    }
    'Solaris': {
      class { 'profile::os::dns_resolver':
        name_servers => $name_servers,
        search_path  => $search_path,
      }
      include profile::os::solaris::enable_ssh
    }
    default: {
      fail("OS family ${facts['os']['family']} is not supported with ${title}.")
    }
  }
}
