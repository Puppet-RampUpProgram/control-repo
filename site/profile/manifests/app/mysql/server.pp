# This is an example profile to install
# MYSql
class profile::app::mysql::server (
  # root_password is set in hiera data based on role and env_n_role
  #  Please delete files in "<control-repo/data/**/*.yaml"
  Sensitive[String] $root_password,
  Array[String] $mysql_bindings = [ 'php' ],
  Hash[String, Hash[String, Any]] $dbs = {},
) {
  #This will do a lookup to create one large hash from the hiera data
  $lookup_settings = lookup( { 'name' => 'profile::app::mysql::server::settings',
                                merge => {
                                  'stratagy' => 'deep',
                                  'knockout_prefix' => '--',
                                },
  })
  assert_type(Hash[String, Any], $lookup_settings)

  }
  class {  'mysql::server':
    root_password => $root_password,
      *           => $lookup_settings,
  }
  $mysql_bindings.each | String $binding | {
    contain "mysql::bindings::${binding}"
  }
  contain mysql::server

  $dbs.each |$dbname, $opts| {
    mysql::db { $dbname:
      * => $opts,
    }
  }

  # @summary Install the MySQL database server
#
# @see https://forge.puppet.com/puppetlabs/mysql
#
# @example Basic usage
#   include r_profile::database::mysql_server
#
# @example Server settings
#   r_profile::database::mysql_server::settings:
#     root_password: "TopSecr3t"
#     remove_default_accounts: true
#
# @example Database creation
#   r_profile::database::mysql_server::dbs:
#     'mydb':
#       user: 'myuser'
#       password: 'mypass'
#       host: 'localhost'
#       grant:
#         - 'SELECT'
#         - 'UPDATE'
#
# @param settings Hash of server settings to enforce (see examples)
# @param dbs Hash of databases to create (see examples)

  class { 'mysql::server':
    * => $settings,
  }

  $dbs.each |$key, $opts| {
    mysql::db { $key:
      * => $opts,
    }
  }

}
}
