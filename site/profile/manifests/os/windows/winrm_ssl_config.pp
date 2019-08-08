# This profile configures winrm to use SSL, and uses
# an existing certificate already installed in the
# trusted store.
#
# This assumes a root CA has already been passed
# via GPO or the like.
#
# Required modules in Puppetfile format, versions current as of last update:
# mod 'puppet-windows_firewall', '2.0.0'
# mod 'puppetlabs-stdlib', '4.24.0'     ( windows_firewall (>= 4.6.0 < 5.0.0))
# mod 'puppetlabs-registry', '1.1.4'    ( windows_firewall (>= 1.1.1 < 2.0.0))
# mod 'liamjbennett-win_facts', '0.0.2' ( windows_firewall (>= 0.0.2 < 2.0.0))
# mod 'nekototori-winrmssl', '0.1.0'
class profile::os::windows::winrm_ssl_config {

  winrmssl { 'example.com':
    ensure => 'present',
    issuer => 'CN=example.com, DC=example, DC=com',
  }

  windows_firewall::exception { '$CLIENT_WINRM_SSL':
    ensure       => 'present',
    direction    => 'in',
    action       => 'Allow',
    enabled      => 'yes',
    protocol     => 'TCP',
    local_port   => '5986',
    remote_port  => 'any',
    display_name => '$CLIENT_WINRM_SSL',
    description  => 'Inbound rule for secure remote management. [TCP 5986]',
  }

}
