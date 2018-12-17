# This will disable UAC on Windows nodes.
#
# Requires: puppetlabs/registry
#
class profile::os::windows::disable_uac {

  registry::value { 'Disable UAC':
    key   => 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System',
    value => 'EnableLUA',
    data  => '0',
    type  => 'dword',
  }

  # Refer to the link below to determine what different values do.
  # Valid data values are 0 - 5.
  # https://msdn.microsoft.com/en-us/library/Cc232761.aspx
  registry::value { 'Set UAC Consent Prompt Level':
    key   => 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System',
    value => 'ConsentPromptBehaviorAdmin',
    data  => '5',
    type  => 'dword',
  }

}

