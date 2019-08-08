# Assuming you have the root CA cert stored on the master
# this declaration will allow you to push it around
# so a linux node can use it for web services
# and windows users will get internally trusted certs
# without needing to provision third party certs
class profile::os::linux::ms_ca_root_cert {

  file { '/etc/pki/tls/certs/msca.crt':
    ensure => 'file',
    source => 'puppet:///modules/profile/msca.crt',
  }

  file { '/etc/pki/tls/certs/4adae044.0':
    ensure  => 'link',
    target  => '/etc/pki/tls/certs/msca.crt',
    require => File['/etc/pki/tls/certs/msca.crt'],
  }

}
