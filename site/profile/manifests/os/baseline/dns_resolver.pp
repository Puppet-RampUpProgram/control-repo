# @summary     A DNS profile for *nix and Windows
#
# @description This profile abstracts away the configuration of DNS settings into
#              2 parameters, 'name_servers' and 'search_path'.
#
# @param name_servers An array of DNS name servers to use.
# @param search_path An array of domain suffixes to use in the DNS search path.
#
class profile::os::baseline::dns_resolver (
  Array[String[1]] $name_servers,
  Array[String[1]] $search_path,
) {

  case $facts['kernel'] {
    'Linux','SunOS': {

      # Use saz/resolv_conf Forge module
      class { 'resolv_conf':
        nameservers => $name_servers,
        searchpath  => $search_path,
      }

    }
    'windows': {

      # Use the puppetlabs/dsc module
      # Rather than set every interface, you could instead just set the primary
      # by changing the dsc_interfacealias param to $facts['networking']['primary']
      # and removing the each loop.
      #$facts['networking']['interfaces'].keys.each |$interface| {
      #  dsc_xdnsserveraddress { "Configure-DNS-${interface}-interface":
      #    ensure             => present,
      #    dsc_address        => $name_servers,
      #    dsc_interfacealias => $interface,
      #    dsc_addressfamily  => 'IPv4',
      #  }
      #}
      dsc_xdnsserveraddress { 'Configure-DNS-primary-interface':
        ensure             => present,
        dsc_address        => $name_servers,
        dsc_interfacealias => $facts['networking']['primary'],
        dsc_addressfamily  => 'IPv4',
      }
      dsc_xdnsclientglobalsetting { 'Configure-DNS-search-path':
        ensure               => present,
        dsc_suffixsearchlist => $search_path,
        dsc_issingleinstance => 'Yes'
      }

    }
    default: { fail("This profile does not support your OS type ${facts['kernel']}") }
  }

}
