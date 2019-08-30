# This is an example profile to install
# MYSql
class profile::app::mysql::server (
  # root_password is set in hiera data based on role and env_n_role
  #  Please delete files in "<control-repo/data/**/*.yaml"
  Sensitive[String] $root_password,
  Array[String] $mysql_bindings = [ 'php' ],
) {
  class {  'mysql::server':
    root_password => $root_password,
  }
  $mysql_bindings.each | String $binding | {
    contain "mysql::bindings::${binding}"
  }
  contain mysql::server
}
