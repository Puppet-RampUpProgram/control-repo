# This profile will enable remote desktop connections
#
# Requires: puppetlabs/registry
#
class profile::os::windows::enable_remote_desktop {

  registry::value { 'Enable Terminal Services connections':
    key   => 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server',
    value => 'fDenyTSConnections',
    data  => '0',
    type  => 'dword',
  }

  registry::value { 'Enable TS Network Level Authentication':
    key   => 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp',
    value => 'SecurityLayer',
    data  => '1',
    type  => 'dword',
  }

}
