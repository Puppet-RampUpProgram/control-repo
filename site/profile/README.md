# Puppet Example Profiles

This directory is working example profiles for customers to use as well as model
future development after.  They should follow best practice and model a multi OS 
use case.

It SHOULD go without saying that everything should pass linting/validation, but
we're gonna go ahead and say that anyway.

## Organization and Namespaces

Profile sprawl is a real concern. To prevent that, please try to follow a convention.

Profiles should be organized in a hierarchical form with a few top-level categories that descend into more specific things. DO NOT just throw all your profiles at the root of the `manifests/` folder. Oh, and please use sub-folders for related profiles.

### The OS folder

`./manifests/os/`

  * This directory should contain profiles that manage items built-in to an operating system. For example, DNS, NTP, Users, firewall rules, etc....
  * If the thing being managed is "out of the box", it goes here.

`./manifests/os/baseline.pp`

  * Profile that will wrap the OS level profiles 
  * Profile that build to support all business supported OS.
  * Profile to implement the minimium base that security, product and sysadmins will allow on a company network.
  * Profile built to install the base software for a company that is identified as site wide software, ie backup etc.

`./manifests/os/<os_name>/<what it is for>`

  * Profiles that are specific to built-in settings of one operating system go here.
  * For example, `/manifests/os/windows/security.pp`, `/manifests/os/linux/firewall.pp`, or `/manifests/os/solaris/enable_ssh.pp`.

### The App folder

`./manifests/app/<app subdir>/<profile name>.pp`

  * This directory should contain profiles to manage applications stacks.
  * An "app" is anything that does **not** come out of the box or is **not** built-in to the operating system.
  * Use simple and easy to understand sub folders that describe the type of application being managed.
    * For example, `app/liferay.pp` is **bad**. While `app/cms/liferay.pp` is better as it groups it in the "CMS" category.
  * Avoid ambiguous profile names. `profile::app::splunk::forwarder` is better than `profile::app::splunk`.
  * Other examples: `/manifests/app/apache.pp`, `/manifests/app/sql/server.pp`, or `/manifests/app/f5/load_balancer.pp`.

`./manifests/cloud/<cloud provider>/<profile name>.pp`

  * This directory is for profiles that will be used to implement cloud API services.
  * This should be things like profiles to communicate to API's like Azure, Google Cloud, OpenStack, etc.

`./lib/facter/`

  * This will be used a location to store site (company) specific facts not specific to a component module.

`./functions/`

  * This directory is for site specific functions not related to modules.
