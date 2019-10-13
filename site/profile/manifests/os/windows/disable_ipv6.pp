# This will turn off ipv6 for Windows nodes
#
# Requires puppetlabs/registry
#
class profile::os::windows::disable_ipv6 {

  registry::value { 'Disable IPv6':
    key   => 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters',
    value => 'DisabledComponents',
    data  => '255',
    type  => 'dword',
  }

}
