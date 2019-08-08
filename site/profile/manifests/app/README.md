### The App folder

`./manifests/app/<app subdir>/<profile name>.pp`

  * This directory should contain profiles to manage applications stacks.
  * An "app" is anything that does **not** come out of the box or is **not** built-in to the operating system.
  * Use simple and easy to understand sub folders that describe the type of application being managed.
    * For example, `app/liferay.pp` is **bad**. While `app/cms/liferay.pp` is better as it groups it in the "CMS" category.
  * Avoid ambiguous profile names. `profile::app::splunk::forwarder` is better than `profile::app::splunk`.
  * Other examples: `/manifests/app/apache.pp`, `/manifests/app/sql/server.pp`, or `/manifests/app/f5/load_balancer.pp`.
