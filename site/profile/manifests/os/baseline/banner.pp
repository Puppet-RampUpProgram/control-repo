# This class will setup MOTD for Windows and Linux hosts
class profile::os::baseline::banner (
  String $motd,
) {
  class { 'motd':
    content => $motd,
  }
}
