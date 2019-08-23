class windows_profile::setnetwork (

  $ipadd = $facts['networking']['interfaces']['Ethernet']['ip'],
  $defaultgateway = '192.168.0.1',
  $dnsprimary = '127.0.0.1',
  $dnssecondary = '8.8.8.8',
  $dnsvalidate = true,
  $firewall = { firewall => [
              { firewall => 'domain',  set => false },
              { firewall => 'public',  set => false },
              { firewall => 'private', set => false }],
              }

) {

  dsc_ipaddress { 'setipaddress':
    dsc_addressfamily  => 'IPv4',
    dsc_interfacealias => 'Ethernet',
    dsc_ipaddress      => "${ipadd}",
  }

  dsc_defaultgatewayaddress {'setdefaultgateway':
    dsc_address        => $defaultgateway,
    dsc_interfacealias => 'Ethernet',
    dsc_addressfamily  => 'IPv4',
  }

  dsc_dnsserveraddress {'setdns':
    dsc_address        => "${dnsprimary}, ${dnssecondary}",
    dsc_interfacealias => 'Ethernet',
    dsc_addressfamily  => 'IPv4',
    dsc_validate       => $dnsvalidate,
  }

  $firewall[firewall].each | $key | {
    dsc_firewallprofile {"${key[firewall]}":
      dsc_name    => "${key[firewall]}",
      dsc_enabled => "${key[set]}",
    }
  }
}
