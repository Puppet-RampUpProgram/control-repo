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
  * For example, `/manifests/os/windows/registry.pp`, `/manifests/os/linux/firewall.pp`, or `/manifests/os/solaris/enable_ssh.pp`.

