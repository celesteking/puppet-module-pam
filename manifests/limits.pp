# Define: pam::limits
#   Add an entry to pam_limits config file
#
# Parameters:
#
# [*domain*]
#
# [*type*]
#
# [*item*]
#
# [*value*]
#
# [*priority*]
#
# [*ensure*]
#
define pam::limits (
  $domain = $title,
  $type,
  $item,
  $value,
  $ensure   = present,
  $priority = '10'
) {
  include pam

  $limits_conf = $pam::params::limits_conf

  realize Concat[$limits_conf]
  
  if !(!$pam::params::allow_local_mods) {
    realize Concat::Fragment['limits_conf-local']
  }
  
  Concat::Fragment <| title == 'pam-header' |> { target => $limits_conf }

  concat::fragment { "pam::limits-${domain}-${type}-${item}-${value}":
    ensure  => $ensure,
    target  => $limits_conf,
    content => "${domain} ${type} ${item} ${value}\n",
    order   => $priority,
  }

}
