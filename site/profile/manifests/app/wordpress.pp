# This profile will deploy a wordpress blogserver
class profile::app::wordpress (
  String $mysql_server = 'localhost',
  String $mysql_user = 'wp_db_user',
  Stdlib::HTTPUrl $wp_site_url = "http://${facts['networking']['ip']}/port/4005/",
) {
  if ($mysql_server == 'localhost') {
    contain profile::app::mysql::server
  }

  include apache
  include apache::mod::php
  apache::vhost { $facts['fqdn']:
      port     => '80',
      priority => '00',
      docroot  => '/opt/wordpress',
  }

  class { 'wordpress':
    wp_owner    => 'apache',
    wp_site_url => $wp_site_url,
    require     => Class['apache'],
  }
}
