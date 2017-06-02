class role::all_in_one_pe {

  include profile::puppetmaster
  include pe_code_manager_webhook
  include pe_metric_curl_cron_jobs
  include pe_databases::postgresql_settings

}
