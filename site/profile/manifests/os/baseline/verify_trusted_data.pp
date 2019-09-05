# profile::base::chk_facts_exist
#
# This class to to check and see if required facts are set.
# The list of facts can be placed in hiera or can be set
# when the class is called (param)
#
# @summary Check and see if required trusted.extensions are set
#
# @param extensions_to_check: list of extensions to verify are not undef
#
# @example
#   class { '::profile::os::baseline::verify_trusted_data':
#     extensions_to_check => [ 'pp_product', 'pp_role',
#       'pp_service' ],
#   }
class profile::os::baseline::verify_trusted_data (
  Optional[Array] $extensions_to_check = undef
) {
  if $extensions_to_check != undef {
    $extensions_to_check.each | $key | {
      $extension_name = "trusted.extensions.${key}"
      if "${$extension_name}" == undef { # lint:ignore:only_variable_string
        fail("Required ${extension_name} does not exists!\nExtension must be set!")
      }
    }
  }
}
