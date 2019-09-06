# This is an example profile to install
# MYSql
class profile::app::mysql::server (
  # root_password is set in hiera data based on role and env_n_role
  #  Please delete files in "<control-repo/data/**/*.yaml"
  #Variant[String, Sensitive[String]] $root_password,
  String $root_password,
  Array[String] $mysql_bindings = [ 'php' ],
  Hash $dbs = {},
) {
  #This will do a lookup to create one large hash from the hiera data
  $lookup_settings = lookup( { 'name' => 'profile::app::mysql::server::settings',
                                'merge' => {
                                  'strategy' => 'deep',
                                  'knockout_prefix' => '--',
                                },
  } )
  assert_type(Hash[String, Any], $lookup_settings)

  $tag_for_exported_mysql_users = $trusted['extensions']['pp_preshared_key']

  assert_type(String, $tag_for_exported_mysql_users)

  # This will ensure the root_password is of Sensitive datatype to protect the 
  # root_password from showing up in the logs.  
  # Currently mysql::server expects String not Sensitive[String] that is why
  # this is commented out.
  #$secure_root_pass = $root_password ? {
  #  Sensitive[String] => $root_password,
  #  default           => Sensitive($root_password)
  #}
  $secure_root_pass = $root_password

  class {  'mysql::server':
    root_password => $secure_root_pass,
      *           => $lookup_settings,
  }
  contain mysql::server

  $mysql_bindings.each | String $binding | {
    contain "mysql::bindings::${binding}"
  }

  Mysql_user <<| tag == $tag_for_exported_mysql_users |>>

  $dbs.each |$dbname, $opts| {
    mysql::db { $dbname:
      * => $opts,
    }
  }

}
