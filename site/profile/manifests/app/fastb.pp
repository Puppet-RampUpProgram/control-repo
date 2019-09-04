# This is a example profile to deploy fastb application software.
class profile::app::fastb (
  Stdlib::HTTPSUrl $download_url = 'https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/sureshatt/http-demo.war',
  String $app_dir = 'fastb',
) {
  include profile::app::tomcat::webserver

  $catalina_home = $profile::app::tomcat::webserver::tomcat_install_path


}
