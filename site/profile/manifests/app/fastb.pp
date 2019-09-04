# This is a example profile to deploy fastb application software.
class profile::app::fastb (
  Stdlib::HTTPSUrl $download_url = 'https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/sureshatt/http-demo.war',
  String $app_dir = 'fastb',
) {
  include profile::app::tomcat::webserver

  $catalina_home = $profile::app::tomcat::webserver::tomcat_install_path

  tomcat::instance { 'tomcat8-fastb':
    catalina_home => "${catalina_home}/${app_dir}",
  }

  tomcat::war { 'fastb.war':
    app_base   => "${catalina_home}/${app_dir}/webapps",
    war_source => $download_url,
  }

#  tomcat::instance { 'tomcat-second':
#    catalina_home => '/opt/tomcat',
#   catalina_base => '/opt/tomcat/second',
#  }

  # Change the default port of the second instance server and HTTP connector
#  tomcat::config::server { 'tomcat-second':
#    catalina_base => '/opt/tomcat/second',
#    port          => '8006',
#  }

}
