# This profile will install tomcat 
class profile::app::tomcat::webserver (
  Optional[String] $download_url = undef,
  Stdlib::Absolutepath $tomcat_install_path = '/opt/tomcat',
) {
  require profile::app::java

  if $download_url {
    tomcat::install { $tomcat_install_path:
      source_url => $download_url,
    }
  } else {
    fail("download_url not set for ${title}.")
  }
}
