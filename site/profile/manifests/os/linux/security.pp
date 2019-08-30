# This is a class example for security
class profile::os::linux::security {
  include toughen::auditing
  include toughen::banners
  include toughen::boot
  include toughen::cron
  include toughen::filesystem
  include toughen::init
  include toughen::legacy_services
  include toughen::mandatory_access
  include toughen::network
  include toughen::pam
  include toughen::perms_owners
  include toughen::process
  include toughen::services
  include toughen::shadow
}
