# Copyright © 2019 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause 
#
# @summary This class sets the default values for parameters used by aide.
#
# A description of what this class does
#
# @example
#   include aide::params
class aide::params {
  $package              = 'aide'
  $version              = 'latest'
  $db_path              = '/var/lib/aide/aide.db'
  $db_temp_path         = '/var/lib/aide/aide.db.new'
  $gzip_dbout           = 'no'
  $aide_log             = '/var/log/aide/aide.log'
  $syslogout            = true
  $hour                 = 0
  $minute               = 0
  $nocheck              = false
  $mailto               = undef
  $mail_only_on_changes = false
  $config_template      = 'aide/aide.conf.erb'
  $cron_template        = 'aide/cron.erb'
  $init_timeout         = 300

  case $::osfamily {
    'Debian': {
      $aide_path = '/usr/bin/aide'
      $cat_path  = '/bin/cat'
      $rm_path   = '/bin/rm'
      $conf_path = '/etc/aide/aide.conf'
    }
    'Redhat': {
      $aide_path = '/usr/sbin/aide'
      $cat_path  = '/usr/bin/cat'
      $rm_path   = '/usr/bin/rm'
      $conf_path = '/etc/aide.conf'
    }
    default: {
      $aide_path = '/usr/sbin/aide'
      $cat_path  = '/usr/bin/cat'
      $rm_path   = '/usr/bin/rm'
      $conf_path = '/etc/aide.conf'
      #fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }
}
