# class to help manage server settings
class profile::app::puppet::non_pe_infra_agent (
  String                         $puppet_server = 'puppet.exampledomain.com',
  Stdlib::Absolutepath $path_to_puppet_conf_dir = '/etc/puppetlabs/puppet',
) {
  ini_setting { 'puppet server setting':
    ensure  => present,
    path    => "${path_to_puppet_conf_dir}/puppet.conf",
    section => 'main',
    setting => 'server',
    value   => $puppet_server,
  }
}
