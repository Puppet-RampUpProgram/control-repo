##
# Create a VM in Azure using Resource Manager method.
#
# Caveats:
#  * 'user' can not be "admin".
#  * 'password' must be at least 12 characters.
#
class profile::cloud::azure::vm_test {
  azure_vm { 'vm1':
    ensure         => present,
    location       => 'westus',
    image          => 'OpenLogic:CentOS:7.3:latest',
    user           => 'puppet',
    password       => '6Eji6PB9ErXJ7PrJtWQP',
    size           => 'Basic_A0',
    resource_group => 'my-group',
  }
}

