# This profile disables all local firewalls on Windows nodes.
#
# Requires: puppetlabs/registry
#
class profile::os::windows::disable_firewall {

  registry::value { 'Disable DomainProfile firewall':
    key   => 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\DomainProfile',
    value => 'EnableFirewall',
    data  => '0',
    type  => 'dword',
  }

  registry::value { 'Disable PublicProfile firewall':
    key   => 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\PublicProfile',
    value => 'EnableFirewall',
    data  => '0',
    type  => 'dword',
  }

  registry::value { 'Disable StandardProfile firewall':
    key   => 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\StandardProfile',
    value => 'EnableFirewall',
    data  => '0',
    type  => 'dword',
  }

}

