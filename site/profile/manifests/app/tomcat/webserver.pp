# This profile will install tomcat 
class profile::app::tomcat::webserver (
  Optional[String] $download_url = undef,
  Stdlib::Absolutepath $tomcat_install_path = '/opt/tomcat',
  String[1] $user = 'tomcat',
  String[1] $group = 'tomcat',
  String[1] $service = 'tomcat',
  Integer $port = 8080,
) {
  require profile::app::java

  if $download_url {
    class { 'tomcat':
      catalina_home => $tomcat_install_path,
      user          => $user,
      group         => $group,
    }

    tomcat::install { $tomcat_install_path:
      source_url => $download_url,
      user       => $user,
      group      => $group,
    }

    tomcat::service { $service:
      require => Tomcat::Install[$tomcat_install_path]
    }
  } else {
    fail("download_url not set for ${title}.")
  }
  contain tomcat
}
