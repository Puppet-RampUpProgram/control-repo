# This is a example profile to deploy fastb application software.
class profile::app::fastb (
  Stdlib::HTTPSUrl $download_url = 'https://tomcat.apache.org/tomcat-9.0-doc/appdev/sample/sample.war',
  String $app_dir = 'fastb',
) {
  include profile::app::tomcat::webserver

  $catalina_home = $profile::app::tomcat::webserver::tomcat_install_path

  tomcat::instance { 'tomcat8-fastb':
    catalina_home => $catalina_home,
    catalina_base => "${catalina_home}/${app_dir}",
  }

  tomcat::war { "${catalina_home}/${app_dir}/fastb_app.war":
    catalina_base => "${catalina_home}/${app_dir}",
    war_source    => $download_url,
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

  tomcat::config::server::connector { 'tomcat-fastb-http':
    catalina_base => "${catalina_home}/${app_dir}",
    port          => '8081',
    protocol      => 'HTTP/1.1',
#    additional_attributes => {
#      'redirectPort' => '8443'
#    },
  }

}
