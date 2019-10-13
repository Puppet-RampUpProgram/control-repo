# This will disable Internet Explorer Enhanced Security Configuration
#
# Requires: puppetlabs/registry
#
class profile::os::windows::disable_ieesc {

  registry::value { 'Disable IE ESC for Administrators':
    key   => 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}',
    value => 'IsInstalled',
    data  => '0',
    type  => 'dword',
  }

  registry::value { 'Disable IE ESC for Users':
    key   => 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}',
    value => 'IsInstalled',
    data  => '0',
    type  => 'dword',
  }

}

