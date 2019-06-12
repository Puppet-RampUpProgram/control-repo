# This is the profile to use for SAP database servers
class profile::app::sql::sap_server {
  class { 'profile::app::sql::common':
    use_sql_as_security_mode => true,
    sql_collation            => 'SQL_Latin1_General_CP850_BIN2',
  }
}
