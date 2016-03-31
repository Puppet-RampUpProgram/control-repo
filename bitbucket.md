# Bitbucket

1. Install Bitbucket
 - https://www.atlassian.com/software/bitbucket/download

1. Make a `Project` called `puppet` (with a short name of `PUP`)

1. Create a repository called `control-repo`

1. * Create a user called `r10k` with a password of `puppet`.
   * Make the r10k user an admin of the `PUP` project.

1. Either use the admin user to test pushing code, or create a user for yourself and add your SSH key to that user.
  * If making a user for yourself, give your user account read/write or admin privilege to the `PUP` project.

## Manually

### Using The Post-Recieve Hook Plugin (Requires Java KS change)

1. Install the following BitBucket Server plugin by logging into the web GUI of the Stash server and going to `Find new add-ons`.
  * https://marketplace.atlassian.com/plugins/com.atlassian.stash.plugin.stash-web-post-receive-hooks-plugin/server/overview
  * You can also install it manually by downloading the jar (https://confluence.atlassian.com/display/UPM/Installing+add-ons)

1. Add the Puppet Master's CA cert to the Java keystore on the BitBucket server:
  * Determine the $JAVA_HOME value used for BitBucket by looking in:

    `/opt/atlassian/bitbucket/<version>/bin/setenv.sh`.
    * You can also look at the `System Information` page of the Web GUI. In my case, it's `/opt/atlassian/bitbucket/4.3.2/jre`.

  * Run the following command and replace `$JAVA_HOME` with the path just determined:

    ```
    $JAVA_HOME/bin/keytool -import -alias puppet-server -file /etc/puppetlabs/puppet/ssl/certs/ca.pem -keystore $JAVA_HOME/lib/security/cacerts
    ```

    * When asked for a password, use `changeit`.

1. Configure the hook on your control repo.
  * Click the `Hooks` tab under the repo's settings.
  * Click the pencil icon next to `Post-Receive WebHooks`
  * The URL to drop in should be in the format of:
    ```
    https://puppet-master:8170/code-manager/v1/webhook?type=stash&token=<TOKEN>
    ```
    * Replace \<TOKEN\> with the RBAC Token that was generated automatically for you (see /etc/puppetlabs/puppetserver/.puppetlabs/deploy_token)

### Using the External Hook Plugin

1. Install the following BitBucket Server plugin by logging into the web GUI of the Stash server and going to `Find new add-ons`.
  * https://marketplace.atlassian.com/plugins/com.ngs.stash.externalhooks.external-hooks/server/overview
  * You can also install it manually by downloading the jar (https://confluence.atlassian.com/display/UPM/Installing+add-ons)

1. Configure the hook on your control repo.
  * Click the `Hooks` tab under the repo's settings.
  * Click the pencil icon next to `External Post-Receive WebHooks`
  * Point to an executable script. For example:
  ##### Deploy just to production:
    ```
#!/usr/bin/env bash
echo "Invoking a deployment from Bitbucket... "
curl -v -k -X POST -H 'Content-Type: application/json' \
https://puppetmaster:8170/code-manager/v1/deploys?token=`cat /var/opt/deploy_token.txt` \
-d '{"environments": ["production"], "wait": true}' | cat
    ```
  ##### Deploy all environments:
    ```
#!/usr/bin/env bash
echo "Invoking a deployment from Bitbucket... "
curl -v -k -X POST -H 'Content-Type: application/json' \
https://puppetmaster:8170/code-manager/v1/deploys?token=`cat /var/opt/deploy_token.txt` \
-d '{"deploy-all": true, "wait": true}' | cat
    ```

  1. You will need to make sure that the Bitbucket server has a deploy token avaliable at `/var/opt/deploy_token.txt`.

## Automatically

A Rampup Bitbucket profile available here: https://github.com/PuppetLabs-RampUpProgram/rampup_profile_bitbucket_server

A working Vagrant example of using Puppet Enterprise with Code Manager and Stash is avaliable here: https://github.com/petems/pe-bitbucket-vagrant-stack
