# This is a example profile to deploy fastb application software.
class profile::app::fastb (
  Stdlib::HTTPSUrl $download_url = 'https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/sureshatt/http-demo.war',
  String $app_dir = 'fastb',
) {
  include profile::app::tomcat::webserver

  $user           = $profile::app::tomcat::webserver::user
  $group          = $profile::app::tomcat::webserver::group
  $service        = $profile::app::tomcat::webserver::service
  $catalina_home = $profile::app::tomcat::webserver::tomcat_install_path

  tomcat::war { 'http-demo.war':
    war_source => $download_url,
    user       => $user,
    group      => $group,
    notify     => Service[$service],
  }
}
