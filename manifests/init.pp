class pam {
  include pam::params
  include concat::setup

  # pam_access
  @concat { $pam::params::access_conf:
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }
  
  # pam_limits
  @concat { $pam::params::limits_conf:
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  @concat::fragment{ 'access_conf-local':
    target => $pam::params::access_conf,
    ensure  => $pam::params::access_conf_local,
    order   => 05
  }
  
  @concat::fragment{ 'limits_conf-local':
    target => $pam::params::limits_conf,
    ensure  => $pam::params::limits_conf_local,
    order   => 05
  }

  # header
  @concat::fragment { "pam-header":
    target  => undef,
    order   => 01,
    content => $pam::params::disclaimer,
  }
}
