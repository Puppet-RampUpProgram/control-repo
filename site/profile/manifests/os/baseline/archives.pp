# This profile is to normalize archive for a site
# it will set temp dir and install dir for the build
class profile::os::baseline::archives (
  Optional[Stdlib::Absolutepath] $in_temp_path = undef,
) {
  include '::archive'

  if ! $in_temp_path {
    case $facts['kernel'] {
      'Linux', 'SunOS': {
        $temp_path = '/tmp'
      }
      'windows': {
        $temp_path = 'C:/Windows/Temp'
      }
      default: {
        fail("OS ${facts['kernel']} is not supported with ${title}.")
      }
    }
  } else {
    $temp_path = $in_temp_path
  }

}
