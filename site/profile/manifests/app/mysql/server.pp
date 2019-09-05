# This is an example profile to install
# MYSql
class profile::app::mysql::server (
  # root_password is set in hiera data based on role and env_n_role
  #  Please delete files in "<control-repo/data/**/*.yaml"
  Variant[String, Sensitive[String]] $root_password,
  Array[String] $mysql_bindings = [ 'php' ],
  Hash[String, Hash[String, Any]] $dbs = {},
) {
  #This will do a lookup to create one large hash from the hiera data
  $lookup_settings = lookup( { 'name' => 'profile::app::mysql::server::settings',
                                merge => {
                                  'stratagy' => 'deep',
                                  'knockout_prefix' => '--',
                                },
  } )
  assert_type(Hash[String, Any], $lookup_settings)

  $secure_root_pass = $root_password ? {
    Sensitive[String] => $root_password,
    default           => Sensitive($root_password)
  }

  class {  'mysql::server':
    root_password => $secure_root_pass,
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

}
