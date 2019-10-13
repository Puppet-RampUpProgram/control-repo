# This class can be used to enforce site specific settings on the
# masters
class profile::app::puppet::masters (
  Optional[String] $puppet_ca = undef,
  Boolean $debug_messages = false,
) {
  if $facts['pe_server_version'] {
    include puppet_enterprise

    # This will quiery the puppet_db to see what hosts are running as the Puppet CA.
    $puppetdb_puppet_ca = 'resources[certname] { type = "Class" and title = "Puppet_enterprise::Profile::Certificate_authority" }'
    $puppet_ca_nodes = puppetdb_query($puppetdb_puppet_ca).each |$value| { $value["certname"] }
    # This will check if puppet_ca param was assigned and if not use $puppet_enterprise::certificate_authority_host
    if $puppet_ca == undef {
      $pe_ca = $puppet_enterprise::certificate_authority_host
    } else {
      $pe_ca = $puppet_ca
    }

    # This code will include a class on compilers but not on the puppet_ca (Master of Masters)
    if (! $trusted['certname'] in $puppet_ca_nodes) and (! $trusted['certname'] == $pe_ca) {
      include profile::app::puppet::compiler
    } else {
      # This is a Master of Masters section to add classes to
      if $debug_messages {
        notify { 'Master message':
          message => "${facts['fqdn']} is running the Puppet_enterprise::Profile::Certificate_authority class",
        }
      }
    }
  }
  include profile::app::puppet::check_hiera_keys

}
