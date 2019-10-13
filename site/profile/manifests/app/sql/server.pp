# Class: profile::app::sql::server
#
#
class profile::app::sql::server (
# Commented out due to mount not working
#  Stdlib::Absolutepath $sql_iso_to_mount,
  String[1] $sa_password,
  Stdlib::Absolutepath $temp_db_location                                               = 'D:\\TempDB',
  Stdlib::Absolutepath $sql_source                                                     = 'K:\\',
  String[1] $sql_version_fact                                                          = 'SQL_2017',
  Boolean $use_sql_as_security_mode                                                    = false,
  Array $sql_feature_array                                                             = [ 'Conn', 'BC', 'SDK' ],
  Enum['SQL_Latin1_General_CP1_CI_AS', 'SQL_Latin1_General_CP850_BIN2'] $sql_collation = 'SQL_Latin1_General_CP1_CI_AS',
) {
  # resources
  file { $temp_db_location:
    ensure => directory,
  }

#  if $facts['sqlserver_instances'][$sql_version_fact].empty and $facts['sqlserver_features'][$sql_version_fact] !=  $sql_feature_array {
#    class {'profile::tools::map_install_storage':
#      iso_to_mount => $sql_iso_to_mount,
#      before       => [ Sqlserver_instance['MSSQLSERVER'],Sqlserver_features['Generic Features'] ],
#    }
#  }

  if $use_sql_as_security_mode {
    sqlserver_instance { 'MSSQLSERVER':
      source                => $sql_source,
      features              => ['SQLEngine','FullText'],
      security_mode         => 'SQL',
      sa_pwd                => $sa_password,
      sql_svc_account       => 'SYSTEM',
      install_switches      => {
        'SQLTEMPDBDIR' => $temp_db_location,
        'SQLCOLLATION' => $sql_collation,
      },
      agt_svc_account       => 'SYSTEM',
      sql_sysadmin_accounts => 'BUILTIN\Administrators',
      require               => File[$temp_db_location],
    }
  } else {
    sqlserver_instance { 'MSSQLSERVER':
      source                => $sql_source,
      features              => ['SQLEngine','FullText'],
      sql_svc_account       => 'SYSTEM',
      install_switches      => {
        'SQLTEMPDBDIR' => $temp_db_location,
        'SQLCOLLATION' => $sql_collation,
      },
      agt_svc_account       => 'SYSTEM',
      sql_sysadmin_accounts => 'BUILTIN\Administrators',
      require               => File[$temp_db_location],
    }
  }

  sqlserver_features { 'Generic Features':
    source   => $sql_source,
    features => $sql_feature_array,
    require  => Sqlserver_instance['MSSQLSERVER'],
  }

# Resource to connect to the DB instance
sqlserver::config { 'MSSQLSERVER':
  admin_login_type => 'WINDOWS_LOGIN'
}

sqlserver::login {'sa':
  instance => 'MSSQLSERVER',
  disabled => true,
  }

  reboot { 'reboot after sql installation change':
      subscribe => [Sqlserver_instance['MSSQLSERVER'],Sqlserver_features['Generic Features']],
    }
}
