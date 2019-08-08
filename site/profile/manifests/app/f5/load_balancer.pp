# profile::app::f5::load_balancer
#
# @summary This is a defined-type profile that creates everything
#          needed in an F5 to load-balance a set of servers.
#
# @example Declaring a set of load-balanced servers:
#
#          profile::app::f5::load_balancer { 'Awesome WebApp':
#            nodes               => [
#               { name => 'web1', address => '10.1.1.11', port => '80' },
#               { name => 'web2', address => '10.1.1.12', port => '80' },
#               { name => 'web3', address => '10.1.1.13', port => '80' },
#            ],
#            pool_name           => 'web_pool',
#            virtualserver_name  => 'website.foo.net',
#            destination_address => '10.1.1.10',
#          }
#
# @param nodes An array of hashes, where each hash contains a 'name', 'address', 'port', and optional 'monitors' key.
# @param pool_name The name of the pool to create and manage.
# @param virtualserver_name The name of the virtualserver to create and mange.
# @param destination_address The IP address of the VIP destination.
#
define profile::app::f5::load_balancer (
  Array[Hash]                $nodes,
  String                     $pool_name,
  String                     $virtualserver_name,
  String                     $destination_address,
  Optional[Array[String]]    $irules                 = undef,
  String                     $destination_mask       = '255.255.255.255',
  Array[String]              $health_monitors        = [ '/Common/tcp' ],
  String                     $load_balancing_method  = 'round-robin',
  Enum['present','absent']   $ensure                 = 'present',
  String                     $http_profile           = '/Common/http',
  String                     $service_port           = '80',
  String                     $source                 = '0.0.0.0',
) {

  $description = "Managed by Puppet: ${title}"

  $_pool_name = $pool_name ? {
    /^\/Common\// => $pool_name,
    default       => "/Common/${pool_name}",
  }

  $_virtualserver_name = $virtualserver_name ? {
    /^\/Common\// => $virtualserver_name,
    default       => "/Common/${virtualserver_name}",
  }

  # Iterate over each node and manage it.
  $nodes.each |Hash $node| {

    # Check that all required node properties are defined.
    ['name','address','port'].each |$property| {
      if !(has_key($node, $property)) or ($node[$property] == undef) {
        fail("${title}: Missing required node property '${property}'")
      }
    }

    # Use the ICMP monitor if none defined.
    $_monitors = $node['monitors'] ? {
      undef   => [ '/Common/icmp' ],
      default => $node['monitors'],
    }

    f5_node { $node['name']:
      ensure                   => $ensure,
      address                  => $node['address'],
      health_monitors          => $_monitors,
      availability_requirement => 'all',
      description              => $description,
      before                   => [
        F5_pool[$_pool_name],
        F5_virtualserver[$_virtualserver_name],
      ],
    }

  }

  # Generate the members parameter value to use in the f5_pool.
  # We are creating an array of hashes with 'name' and 'port' keys.
  $members = $nodes.map |Hash $node| {
    {
      'name' => $node['name'],
      'port' => $node['port'],
    }
  }

  f5_pool { $_pool_name:
    ensure                => $ensure,
    health_monitors       => $health_monitors,
    load_balancing_method => $load_balancing_method,
    members               => $members,
    description           => $description,
    before                => F5_virtualserver[$_virtualserver_name],
  }

  f5_virtualserver {  $_virtualserver_name:
    ensure              => $ensure,
    provider            => 'standard',
    default_pool        => $_pool_name,
    destination_address => $destination_address,
    destination_mask    => $destination_mask,
    http_profile        => $http_profile,
    service_port        => $service_port,
    irules              => $irules,
    source              => $source,
    description         => $description,
    require             => F5_pool[$_pool_name],
  }

}
