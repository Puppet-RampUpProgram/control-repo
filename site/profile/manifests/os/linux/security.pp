# This profile is example of security configurations for 
# site specific security settings.
class profile::os::linux::security (
  # This allows hiera to control if the saz/ssh::server class should be used 
  # on perspective agent hosts.  Setting to false will mean the agents ssh server
  # configuration will not be managed.  If 'profile::os::linux::security::ssh_server'
  # to change this behavior
  Boolean $ssh_server = true
) {
  if $ssh_server {
    # This lookup allows the hash to be constructed over multiple hierarchies
    # example is located in common.yaml and virtual/virtualbox.yaml
    $ssh_server_opts = lookup( 'name' => 'profile::os::linux::security::ssh_server_opts',
      { 'merge'                          => {
        'strategy'                     => 'deep',
        'default_value'                =>  {} }, })

    $ssh_client_opts = lookup( 'name' => 'profile::os::linux::security::ssh_client_opts',
      { 'merge'                          => {
        'strategy'                     => 'deep',
        'default_value'                => {} }, })

    # Pass the found options to saz/ssh server class
    class { 'ssh::server':
      options => $ssh_server_opts,
    }
  }
}
