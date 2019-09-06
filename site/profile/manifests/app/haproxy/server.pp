#class for HaProxy services
class profile::app::haproxy::server(
  Hash[String, Hash[String, Any]] $listeners      = {},
  Hash[String, Hash[String, Any]] $frontends      = {},
  Hash[String, Hash[String, Any]] $backends       = {},
  Enum['enable', 'disable' ]      $admin_stats    = 'disable',
  Array[Integer]                  $stats_port     = [9090],
  String                          $stats_username = 'puppet',
  String                          $stats_password = 'puppet',
) {

  include haproxy

class { 'haproxy':
  global_options   => {
    'log'     => "${facts['ipaddress']} local0",
    'chroot'  => '/var/lib/haproxy',
    'pidfile' => '/var/run/haproxy.pid',
    'maxconn' => '4000',
    'user'    => 'haproxy',
    'group'   => 'haproxy',
    'daemon'  => '',
    'stats'   => 'socket /var/lib/haproxy/stats',
  },
  defaults_options => {
    'log'     => 'global',
    'stats'   => $admin_stats,
    'option'  => [
      'redispatch',
    ],
    'retries' => '3',
    'timeout' => [
      'http-request 10s',
      'queue 1m',
      'connect 10s',
      'client 1m',
      'server 1m',
      'check 10s',
    ],
    'maxconn' => '8000',
  },
}

}
