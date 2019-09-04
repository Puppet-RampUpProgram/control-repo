# This profile os to install an normalize java for 
# agent hosts.
class profile::app::java {
  case $facts['os']['family'] {
    'RedHat', 'Debian': {
      require java
    }
    'windows': {
      require windows_java
    }
    'Solaris': {
      require java
    }
    default: {
      fail("OS family ${facts['os']['family']} is not supported with ${title}.")
    }
  }
}
