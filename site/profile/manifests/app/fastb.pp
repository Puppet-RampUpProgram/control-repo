# This is a example profile to deploy fastb application software.
class profile::app::fastb (
  Stdlib::Httpsurl $download_url = 'https://tomcat.apache.org/tomcat-8.0-doc/appdev/sample/sample.war',
  String $sha1_sum = '80f5053b166c69d81697ba21113c673f8372aca0',
  Stdlib::Absolutepath $app_path = '/opt/tomcat',
) {
  require profile::os::archives
  $temp_dir = $profile::os::archives::temp_dir

  archive { "${temp_dir}/fastb_app.war":
    ensure        => present,
    extract       => true,
    extract_path  => $app_path,
    source        => $download_url,
    checksum      => $sha1_sum,
    checksum_type => 'sha1',
    creates       => "${app_path}/fastb_app.war",
    cleanup       => true,
  }
}
