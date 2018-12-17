# Puppet Example Roles and Profiles

These directories are example layout of Roles and Profiles practice.  They have been constructed to represent current best practice and to support multiple operating systems.

It SHOULD go without saying that everything should pass linting/validation, but
we're gonna go ahead and say that anyway.

## Example requirements

These examples have been constructed with the following requirements:

  - Modeling should support three operating systems
    - Windows 2012R2
    - CentOS (6,7)
    - Solaris 11.2
  - Two products should be represented
    - Spider
      - Windows product
      - IIS Web service
      - F5 loadbalancer
      - SQL Database server
    - Fastb
      - Linux and Solaris product
      - Tomcat web backend
      - HAProxy loadbalancer
      - MYSQL Database server
    - These products are examples and will be deploying a `hello world` code base
