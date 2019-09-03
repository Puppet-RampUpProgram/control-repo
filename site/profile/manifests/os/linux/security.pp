# This is a class example for security
class profile::os::linux::security {
  include toughen::banners
  include toughen::boot
  include toughen::cron
  include toughen::perms_owners
  include toughen::shadow
  include toughen::legacy_services
  include toughen::services
  #include toughen::auditing
  #include toughen::mandatory_access
  #include toughen::network
  #include toughen::pam

}
