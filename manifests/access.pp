# Define: pam::access
#   Add an entry to pam_access config file
#
# Parameters:
#
# [*permission*]
#   Either ("+") or "-".
#
# [*entity*]
#   
# [*origin*]
#   Default is "ALL"
#
# [*priority*]
#
# [*ensure*]
#
define pam::access (
  $permission = '+',
  $entity     = $title,
  $origin     = 'ALL',
  $ensure     = present,
  $priority   = '10'
) {
  include pam

  if ! ($permission in ['+', '-']) {
    fail("Permission must be + or - ; recieved $permission")
  }

  $access_conf = $pam::params::access_conf
  $control_entry = "${permission} : ${entity}\t: ${origin}"

  realize Concat[$access_conf]
  
  if !(!$pam::params::allow_local_mods) {
    realize Concat::Fragment['access_conf-local']
  }
  
  Concat::Fragment <| title == 'pam-header' |> { target => $access_conf }

  concat::fragment { "pam::access-${control_entry}":
    ensure  => $ensure,
    target  => $access_conf,
    content => "${control_entry}\n",
    order   => $priority,
  }

}
