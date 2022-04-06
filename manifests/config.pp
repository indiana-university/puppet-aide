# Copyright © 2019 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause
#
#@summary This class manages aide configurations.
#@param conf_path, db_path, db_temp_path, gzip_dbout, aide_log, syslogout, report_ignore_e2fsattrs and config_template
#       reference README file.
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
  String $report_ignore_e2fsattrs,
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
