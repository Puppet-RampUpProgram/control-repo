# This is a example profile to deploy fastb application software.
class profile::app::fastb (
  Stdlib::HTTPSUrl $download_url = 'https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/sureshatt/http-demo.war',
  String $app_dir = 'fastb',
) {
  require profile::app::tomcat::webserver

  $user          = $profile::app::tomcat::webserver::user
  $group         = $profile::app::tomcat::webserver::group
  $service       = $profile::app::tomcat::webserver::service
  $catalina_home = $profile::app::tomcat::webserver::tomcat_install_path

  tomcat::war { 'http-demo.war':
    war_source => $download_url,
    user       => $user,
    group      => $group,
  }

  @@mysql_user { "fastb_db_user@${facts['fqdn']}":
    ensure        => present,
    password_hash => mysql_password(lookup("profile::app::fastb::fastb_db_password::${trusted['extensions']['pp_preshared_key']}")),
  }
}
