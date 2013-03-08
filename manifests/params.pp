# pam parameters class
class pam::params {

  case $::osfamily {
    'Debian', 'RedHat', 'Suse': {}
    default: { fail("pam::access does not support osfamily $::osfamily") } 
  }
  
  # Whether to allow custom local config to be prepended
  $allow_local_mods = hiera('pam::allow_local_mods', true)
  
  $access_conf = '/etc/security/access.conf'
  $access_conf_local = '/etc/security/access.local.conf'
  
  $limits_conf = '/etc/security/limits.conf'
  $limits_conf_local = '/etc/security/limits.local.conf'

  $disclaimer = sprintf("%s\n%s\n", "# ***   This file is managed by Puppet    ***", "# *** Automatically generated, don't edit ***")
}
