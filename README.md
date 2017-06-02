Table of contents
=================

* [Join the \#ramp\-up channel on Puppet Community Slack](#join-the-ramp-up-channel-on-puppet-community-slack)
* [Before starting](#before-starting)
* [What you get from this control\-repo](#what-you-get-from-this-control-repo)
* [How to set it all up](#how-to-set-it-all-up)
  * [Copy this repo into your own Git server](#copy-this-repo-into-your-own-git-server)
    * [GitLab](#gitlab)
    * [Stash](#stash)
    * [GitHub](#github)
  * [Configure PE to use the control\-repo](#configure-pe-to-use-the-control-repo)
    * [Install PE](#install-pe)
    * [Get the control\-repo deployed on your master](#get-the-control-repo-deployed-on-your-master)
  * [Setup a webhook in your Git server](#setup-a-webhook-in-your-git-server)
    * [Gitlab](#gitlab-1)
  * [Test Code Manager](#test-code-manager)

# Join the #ramp-up channel on Puppet Community Slack

Our [Puppet Community Slack](http://slack.puppet.com) is a great way to interact with other Puppet users.  The #ramp-up channel is specifically for users who are new to Puppet Enterprise and using this repository. Other channels in the Puppet Community Slack are great for asking general Puppet questions.

# Before starting

This control-repo and the steps below are intended to be used with a new installation of PE.

**Warning:** When using an existing PE installation any existing code or modules in `/etc/puppetlabs/code` will be copied to a backup directory `/etc/puppetlabs/code_bak_<timestamp>` in order to allow deploying code from Code Manager.

# What you get from this control-repo

When you finish the instructions below, you will have the beginning of a best practices installation of PE including:

 - A Git server
 - The ability to push code to your Git server and have it automatically deployed to your PE master
 - A config_version script that outputs the most recent SHA of your code each time you run `puppet agent -t`
 - Optimal tuning of PE settings for this configuration
 - Working and example [roles and profiles](https://docs.puppet.com/pe/latest/puppet_assign_configurations.html#assigning-configuration-data-with-role-and-profile-modules) code

# How to set it all up

## Copy this repo into your own Git server

### GitLab

1. On a new server, install GitLab.
 - https://about.gitlab.com/downloads/

2. After GitLab is installed, sign into the web UI with the user `root`.
 - The first time you visit the UI it will force you to enter a password for the `root` user.

2. In the GitLab UI, create a group called `puppet`.
 - http://doc.gitlab.com/ce/workflow/groups.html

3. In the GitLab UI, make yourself a user to edit and push code.

4. From your laptop or development machine, make an SSH key and link it with your GitLab user.
 - Note: The SSH key allows your laptop to communicate with the GitLab server and push code.
 - https://help.github.com/articles/generating-ssh-keys/
 - http://doc.gitlab.com/ce/ssh/README.html

7. In the GitLab UI, add your user to the `puppet` group.
 - You must give your user at least master permissions to complete the following steps.
 - Read more about permissions:
    - https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/permissions/permissions.md

8. In the GitLab UI, create a project called `control-repo` and set its Namespace to the `puppet` group.

10. On your laptop, clone this PuppetLabs-RampUpProgram control repo.
 - `git clone https://github.com/PuppetLabs-RampUpProgram/control-repo.git`
 - `cd control-repo`

14. On your laptop, remove the origin remote.
 - `git remote remove origin`

15. On your laptop, add your GitLab repo as the origin remote.
 - `git remote add origin <SSH URL of your GitLab repo>`

16. On your laptop, push the production branch of the repo from your machine up to your Git server.
 - `git push origin production`

### Stash

Coming soon!

### GitHub

Coming soon!

## Configure PE to use the control-repo

### Install PE

1. Download the latest version of the PE installer for your platform.
 - https://puppetlabs.com/download-puppet-enterprise
2. SSH into your Puppet master and copy the installer tarball into `/tmp`
2. Expand the tarball and `cd` into the directory.
3. Run `puppet-enterprise-installer` to install PE.

If you have any issues with or questions about the installer, see our docs here:

http://docs.puppetlabs.com/pe/latest/install_basic.html

### Deploy control-repo on your master

You've deployed our control-repo code to your Git server. Complete the following steps to:

+ Add your Git credentials to PE.
+ Deploy our control-repo code on your Puppet master.

When you've completed the steps, the Puppet master pulls code from the Git server via Code Manager.

To configure PE to deploy control-repo, make an SSH key on your Puppet master and add it as a deploy key in the Git server.

1. On your Puppet master, make an SSH key so that r10k can connect to GitLab.

  ~~~
  mkdir /etc/puppetlabs/puppetserver/ssh
  /usr/bin/ssh-keygen -t rsa -b 2048 -C 'code_manager' -f /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa -q -N ''
  cat /etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa.pub
  ~~~

 - References:
    - https://help.github.com/articles/generating-ssh-keys/
    - http://doc.gitlab.com/ce/ssh/README.html
2. In the GitLab UI, create a deploy key on the `control-repo` project.
 - Paste in the SSH public key from step 1.
3. Log into the PE console.
4. Navigate to **Nodes > Classification**.
 - Click the **PE Master** group.
 - Click the **Classes** tab.
 - Edit the `puppet_enterprise::profile::master` class:
    - Set the `r10k_remote` parameter to the SSH URL from the front page of your GitLab repo.
    - Set the `r10k_private_key` parameter to `/etc/puppetlabs/puppetserver/ssh/id-control_repo.rsa`
 - **Commit** your changes.
5. On your Puppet master,
 - Run:

    ~~~
    puppet agent -t
    r10k deploy environment -pv
    puppet agent -t
    ~~~

5. In the PE console, navigate to **Nodes > Classification**.
 - Near the top of the page select "add a group".
 - For the group name enter `role::all_in_one_pe`
    - Click the **Add Group** button.
 - Click the **add membership rules, classes and variables** link.
    - Below **Pin specific nodes to the group** enter your master's FQDN.
       - Click **pin node**.
 - Select the **Classes** tab.
    - On the right hand side, click the **Refresh** link.
       - Wait for the classes to refresh.
    - In the **add new classes** field enter `role::all_in_one_pe`
       - Click **add class**.
 - **Commit** your changes.
8. On your Puppet master,
 - Run:

    ~~~
    puppet agent -t
    echo 'code_manager_mv_old_code=true' > /opt/puppetlabs/facter/facts.d/code_manager_mv_old_code.txt
    puppet agent -t
    ~~~

Code Manager is configured and has been used to deploy control-repo's code.

## Setup a webhook in your Git server

Independent of which Git server you choose you will grab the webhook URL from your master.  Then each Git Server will have similar but slightly different ways to add the webhook.

1. On your Puppet master
 - `cat /etc/puppetlabs/puppetserver/.puppetlabs/webhook_url.txt`

### Gitlab

2. In your Git server's UI, navigate to the control-repo repository
 -  In the left hand pane, scroll to the bottom and select **settings**
 - In the left hand pane, select **webhooks**
3. Paste the above webhook URL into the URL field
4. In the trigger section mark the checkbox for **push events** only
3. Disable SSL verification on the webhook
 - Since Code Manager uses a self-signed cert from the Puppet CA it is not generally trusted
3. After you created the webhook use "test webhook" or similar functionality to confirm it works

## Test Code Manager

One of the components setup by this control-repo is that when you "push" code to your Git server, the git server will inform the Puppet master to deploy the branch you just pushed.

1. On your Puppet Master, `tail -f /var/log/puppetlabs/puppetserver/puppetserver.log`.
2. On your laptop in a separate terminal window:
 - Add a new file

    ~~~
    touch test_file
    git add test_file
    git commit -m "adding a test_file"
    git push origin production
    ~~~

3. Allow the push to complete and then wait a few seconds for everything to sync over.
 - On your Puppet Master, `ls -l /etc/puppetlabs/code/environments/production`.
    - Confirm test_file is present
4. In your first terminal window review the `puppetserver.log` to see the type of logging each sync will create.
