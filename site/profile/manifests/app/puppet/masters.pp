# This class can be used to enforce site specific settings on the
# masters
class profile::app::puppet::masters (
  Optional[String] $puppet_ca = undef,
) {
  include puppet_enterprise

  # This section will check repo provided keys in the demo/example
  # control-repo and warn if they are still in use.
  $hiera_private_key = '/etc/puppetlabs/code/environments/production/keys/private_key.pkcs7.pem'
  $hiera_private_key_exists = inline_template("<% if File.exist?('${hiera_private_key}') -%>true<% end -%>")

  # This will quiery the puppet_db to see what hosts are running as the Puppet CA.
  $puppetdb_puppet_ca = [ 'from', 'nodes', ['=', ['type', 'Class'], 'and', ['title', 'Puppet_enterprise::Profile::Certificate_authority']] ]
  $puppet_ca_nodes = puppetdb_query($puppetdb_puppet_ca).each |$value| { $value["certname"] }
  # This will check if puppet_ca param was assigned and if not use $puppet_enterprise::certificate_authority_host
  if $puppet_ca == undef {
    $pe_ca = $puppet_enterprise::certificate_authority_host
  } else {
    $pe_ca = $puppet_ca
  }

  if $hiera_private_key_exists {
    $warning_content = "${hiera_private_key} file should be removed from the control repo and all eyaml encrypted \
    data should be re-encrypted with new keys.  DO NOT PLACE PRIVATE KEY in control-repo! \
    See https://github.com/voxpupuli/hiera-eyaml#generate-keys"

    warning("${warning_content})
    notify { 'key error':
      message => "${warning_content}",
    }
  }

  # This code will include a class on compilers but not on the puppet_ca (Master of Masters)
  if (! $trusted['certname'] in $puppet_ca_nodes) and (! $trusted['certname'] == $pe_ca) {
      include profile::app::puppet::compiler
  } else {
    # This is a Master of Masters section to add classes to
  }

}
