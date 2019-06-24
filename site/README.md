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
      - Windows systems hosting the product
      - IIS Web service 'role::spiders::web_be'
      - HAProxy loadbalancer 'role::spiders::balancer'
      - SQL Database server 'role::spiders::database'
    - Fastb
      - Linux and Solaris systmes hoting the product
      - Tomcat web backend 'role::fastb::web_be'
      - HAProxy loadbalancer 'role::fastb::balancer'
      - MYSQL Database server 'role::fastb::database'
    - These products are examples and will be deploying a `hello world` code base
  - Support services
    - While products usually do not share hosts support services do
    - Example of monitoring service 'role::sup\_svc::monitoring::server'
