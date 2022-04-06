# Copyright © 2019 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause 
#
#@summary This class creates the initial database used for performing checks. For all params reference README.
#
#@param aide_path
#@param cat_path
#@param db_temp_path
#@param db_path
#@param init_timeout
#
# @example
#   include aide::firstrun
class aide::firstrun (
  String $aide_path,
  String $conf_path,
  String $db_temp_path,
  String $db_path,
  Integer $init_timeout,
) {
  exec { 'aide init':
    command     => "nice ionice -c3 ${aide_path} --init --config ${conf_path}",
    user        => 'root',
    path        => ['/usr/bin', '/bin'],
    timeout     => $init_timeout,
    refreshonly => true,
    subscribe   => Concat['aide.conf'],
  }

  exec { 'install aide db':
    command     => "/bin/cp -f ${db_temp_path} ${db_path}",
    user        => 'root',
    refreshonly => true,
    subscribe   => Exec['aide init'],
  }

  file { $db_path:
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0600',
    require => Exec['install aide db'],
  }

  file { $db_temp_path:
    owner   => root,
    group   => root,
    mode    => '0600',
    require => Exec['aide init'],
  }
}
