##
# profile::cloud::azure::deployhost
#
# Builds a host used to interface with Azure (to be used by puppetlabs/azure module).
# Gems and packages are required to be installed into ruby packaged with Puppet Agent.
# Tested on CentOS and Windows 2012R2.
#
# Module requirements:
#  * puppetlabs/hocon
#
# Other requirements:
#  * Azure login (https://azure.microsoft.com/)
#  * Azure Service Principal (SP) with permissions to create objects.
#
# @summary Micosoft Azure deployer proxy host.
#
# @param azure_packages Packages required for azure_gems on Linux.
#
# @param azure_gems Gems required.
#
# @param azure_config
#  subscription_id:
#    * Portal: Subscriptions -> $name -> Subscription ID
#    * CLI 2.0: `az account list --output table`
#  tenant_id:
#    * Portal: Azure Active Directory -> Properties -> Directory ID
#    * CLI 2.0: `az account show --output table`
#  client_id:
#    * Portal: Azure Active Directory -> App Registrations -> $name -> Application ID
#    * CLI 2.0: `az ad app list`
#  client_secret: Only displayed once upon creation of client_id.
#    * Portal: Azure Active Directory -> App Registrations -> New application registration
#    * CLI 2.0: `az ad sp create-for-rbac --name $sp_name`
#
class profile::cloud::azure::deployhost (
  Array $azure_packages = ['gcc-c++', 'zlib-devel'],
  Hash $azure_gems     = {
    'activesupport'         => '4.2.9',
    'nokogiri'              => '~>1.7.0',
    'azure'                 => '~>0.7.0',
    'azure-armrest'         => '0.3.1',
    'azure_mgmt_compute'    => '~>0.3.0',
    'azure_mgmt_storage'    => '~>0.3.0',
    'azure_mgmt_resources'  => '~>0.3.0',
    'azure_mgmt_network'    => '~>0.3.0',
    'hocon'                 => '~>1.1.2',
    'retries'               => 'latest',
  },

  Hash $azure_config    = {
    'subscription_id' => undef,
    'tenant_id'       => undef,
    'client_id'       => undef,
    'client_secret'   => undef,
  }
) {

  ##
  # Packges & Gems
  #
  if $facts['kernel'] == 'Linux' {
    package { $azure_packages:
      ensure => installed,
    }
  }

  $azure_gems.each | String $gem, String $version | {
    package { $gem:
      ensure   => $version,
      provider => 'puppet_gem',
    }
  }

  ##
  # Configuration
  #
  $agent_confdir = $facts['os']['family'] ? {
    'windows' => 'C:/ProgramData/PuppetLabs/puppet/etc',
    default   => '/etc/puppetlabs/puppet',
  }

  $azure_config.each | $i, $v | {
    hocon_setting {"azure.conf-${i}":
      ensure  => present,
      path    => "${agent_confdir}/azure.conf",
      setting => "azure.${i}",
      value   => $v,
    }
  }

}
