# This is an example profile to install
# MYSql
class profile::app::mysql::server (
  # root_password is set in hiera data based on role and env_n_role
  #  Please delete files in "<control-repo/data/**/*.yaml"
  #Variant[String, Sensitive[String]] $root_password,
  String $root_password,
  Array[String] $mysql_bindings = [ 'php' ],
  Hash[String, Hash[String, Any]] $dbs = {},
) {
  #This will do a lookup to create one large hash from the hiera data
  $lookup_settings = lookup( { 'name' => 'profile::app::mysql::server::settings',
                                'merge' => {
                                  'strategy' => 'deep',
                                  'knockout_prefix' => '--',
                                },
  } )
  assert_type(Hash[String, Any], $lookup_settings)

  $lookup_mysql_users = lookup( { 'name' => 'profile::app::mysql::server::mysql_users',
                                'merge' => {
                                  'strategy' => 'deep',
                                  'knockout_prefix' => '--',
                                },
  } )
  assert_type(Hash[Hash, Any], $lookup_mysql_users)

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

  $lookup_mysql_users.each |String $username, Hash $user_opts| {
    $password_hash = mysql_password(lookup("profile::app::mysql::server::${username}::password"))
    mysql_user { $username:
      password_hash => $password_hash,
      *             => $user_opts,
    }
  }

  $dbs.each |$dbname, $opts| {
    mysql::db { $dbname:
      * => $opts,
    }
  }

}
