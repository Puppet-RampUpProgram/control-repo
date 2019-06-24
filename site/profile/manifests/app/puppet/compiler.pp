# class profile::app::puppet::compiler
# This profile has a chicken and egg complex
# The content of the keys cannot reside in hiera-eyaml until Primary Master has been configured.
class profile::app::puppet::compiler (
  String $ssh_private_key_content,
  String $ssh_public_key_content,
  String $eyaml_private_key_content,
  String $eyaml_public_key_content,
) {

  file { [ '/etc/puppetlabs/puppet/eyaml', '/etc/puppetlabs/puppetserver/ssh/' ]:
    ensure => directory,
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0750',
  }

  file { '/etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa':
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    content => $ssh_private_key_content,
  }

  file { '/etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa.pub':
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    content => $ssh_public_key_content,
  }

  file { '/etc/puppetlabs/puppet/eyaml/private_key.pkcs7.pem':
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0600',
    content => $eyaml_private_key_content,
  }

  file { '/etc/puppetlabs/puppet/eyaml/public_key.pkcs7.pem':
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0644',
    content => $eyaml_public_key_content,
  }
}
