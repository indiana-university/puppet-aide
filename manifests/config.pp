# Copyright © 2022 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause
#
#@summary This class manages aide configurations.
#@param conf_path
#@param db_path
#@param db_temp_path
#@param gzip_dbout
#@param aide_log
#@param syslogout
#@param report_ignore_e2fsattrs
#@param config_template
#
#@example
#   include aide::config
class aide::config (
  String $conf_path,
  String $db_path,
  String $db_temp_path,
  Boolean $gzip_dbout,
  String $aide_log,
  Boolean $syslogout,
  Optional[String] $report_ignore_e2fsattrs,
  String $config_template,
) {
  concat { 'aide.conf':
    path  => $conf_path,
    owner => 'root',
    group => 'root',
    mode  => '0600',
  }

  concat::fragment { 'aide.conf.header':
    target  => 'aide.conf',
    order   => '01',
    content => template( $config_template ),
  }

  concat::fragment { 'rule_header':
    target  => 'aide.conf',
    order   => '02',
    content => "\n# User defined rules\n",
  }

  concat::fragment { 'watch_header':
    target  => 'aide.conf',
    order   => '45',
    content => "\n# Files and directories to scan\n",
  }
}
