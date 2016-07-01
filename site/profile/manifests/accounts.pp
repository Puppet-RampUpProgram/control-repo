# This class wraps the puppetlabs/accounts module and the native
# group type to create accounts and groups from hiera.
#
# Enteries in Hiera should look like this:
#
# accounts_hash:
#   bob:
#     uid: '4001'
#     gid: '4001'
#     shell: '/bin/bash'
#     password: '!!'
#     sshkeys:
#       - 'ssh-rsa AAAA...'
#     locked: false
#   sue:
#     uid: '4002'
#     gid: '4002'
#     shell: '/bin/ksh'
#     password: '!!'
#     sshkeys:
#       - 'ssh-rsa BBBB...'
#     locked: false
class profile::accounts (
  $accounts = hiera_hash('accounts_hash',{}),
  $groups = hiera_hash('groups_hash',{}),
) {

  $accounts.each |$key, $value| {
    accounts::user { $key:
      ensure               => $value['ensure'],
      shell                => $value['shell'],
      comment              => $value['comment'],
      home                 => $value['home'],
      home_mode            => $value['home_mode'],
      uid                  => $value['uid'],
      gid                  => $value['gid'],
      groups               => $value['groups'],
      membership           => $value['membership'],
      password             => $value['password'],
      locked               => $value['locked'],
      sshkeys              => $value['sshkeys'],
      managehome           => $value['managehome'],
      bashrc_content       => $value['bashrc_content'],
      bash_profile_content => $value['bash_profile_content'],
    }
  }

  $groups.each |$key, $value| {
    group { $key:
      ensure => $value['ensure'],
      allowdupe => $value['allowdupe'],
      attribute_membership => $value['attribute_membership'],
      attributes           => $value['attributes'],
      auth_membership      => $value['auth_membership'],
      forcelocal           => $value['forcelocal'],
      gid                  => $value['gid'],
      ia_load_module       => $value['ia_load_module'],
      members              => $value['members'],
      provider             => $value['provider'],
      system               => $value['system'],
    }
  }
}
