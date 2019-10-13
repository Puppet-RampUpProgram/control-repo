# This class enables SSH and enables root login

class profile::os::solaris::enable_ssh (
  String $permit_root_login = 'yes',
) {

  # Start up the service and enable it at boot time.
  service { 'svc:/network/ssh:default':
    ensure => running,
    enable => true,
  }

  # Manage whether root is allowed to login.  (Default: yes)
  file_line { 'permit root ssh':
    ensure => present,
    path   => '/etc/ssh/sshd_config',
    line   => "PermitRootLogin ${permit_root_login}",
    match  => '^PermitRootLogin ',
    notify => Service['svc:/network/ssh:default'],
  }

}
