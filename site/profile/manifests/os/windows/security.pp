# This profile is example of security configurations for 
# site specific security settings.
class profile::os::windows::security (
  Boolean $disable_ipv6 = true,
  Boolean $enable_rdesktop = false,
) {
  if $disable_ipv6 {
    include profile::os::windows::disable_ipv6
  }
  if $enable_rdesktop {
    include profile::os::windows::enable_remote_desktop
  }
  contain secure_windows
}
