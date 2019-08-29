# Puppet Example Roles

This directory is working example roles for customers to use as well as model
future development after.  They should follow best practice and model a multi OS 
use case.

It SHOULD go without saying that everything should pass linting/validation, but
we're gonna go ahead and say that anyway.

## Organization and Namespaces

Roles should be organized in a hierarchical form with product categories that descend into more specific services for the product. DO NOT just throw all your roles at the root of the `manifests/` folder. Oh, and please use sub-folders for related roles.

### The Product folders

`/manifests/<product>/`

  * This directory should contain example roles that manage nodes running specific product line functions.
  * For example:
    * `./manifests/fastb/web_be.pp` is `FastB product Web Backend`.
    * `./manifests/spiders/database.pp` is `Spiders product SQL Database Backend`. 
  
