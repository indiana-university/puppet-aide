# Copyright © 2019 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause
#
#@summary The aide class manages the installation and configuration of aide
#
# @example
#   include aide
#
# @param package
#   AIDE package name. Default is set to aide.
#
# @version
#   AIDE version for installation passed to Package::ensure. Default is set to latest.
#
# @conf_path
#   Location of AIDE configuration file.
#
# @db_path
#   Location of AIDE database file.
#
# @db_temp_path
#   Location of update AIDE database file.
#
# @gzip_dbout
#   Gzip the AIDE database file (may affect performance). Default is set to not gzip the database file.
#
# @aide_path
#   Location of aide binary.
#
# @config_template
#   Template to use for aide configuration.
#
# @aide_log
#   AIDE check output log.
#
# @syslogout
#   Enables logging to the system logging service AUTH facility and '/var/log/messages'.
#
# @hour
#   Hour of cron job to run.
#
# @minute
#   Minute of cron job to run.
#
# @nocheck
#   Whether to enable or disable scheduled checks.
#
# @mailto
#   Set this vaule to send email of results from aide --check in cron.
#
# @mail_only_on_changes
#   If mail_only_on_changes is set to true,
#   mails are only sent if changes are detected by AIDE.
#   By default this flag is set to false
#
# @init_timeout
#   Allows to adjust timeout of the "aide --init" run.
#   Puppet default exec timeout is 300 (which is also kept),
#   but this may be insufficient for more complex aide DBs.
#
# @report_ignore_e2fsattrs
#   List (no delimiter) of ext2 file attributes which are
#   to be ignored in the final report.
#   See chattr(1) for the available attributes.
#   Use '0' to not ignore any attribute.
#   Ignored attributes are represented by a ':' in the output.
#   The default is to not ignore any ext2 file attribute.

class aide (
  $package,
  $version,
  $conf_path,
  $db_path,
  $db_temp_path,
  $gzip_dbout,
  $aide_path,
  $config_template,
  $aide_log,
  $syslogout,
  $hour,
  $minute,
  $nocheck,
  $mailto,
  $mail_only_on_changes,
  $init_timeout,
  $report_ignore_e2fsattrs,
  $cat_path,
  $rm_path,
  $mail_path,
){

  # Used to throttle I/O and CPU load of AIDE.
  package { 'util-linux':
    ensure => 'present',
  }

  package { $package:
    ensure => $version,
  }

  -> class { '::aide::cron':
      aide_path            => $aide_path,
      cat_path             => $cat_path,
      rm_path              => $rm_path,
      mail_path            => $mail_path,
      minute               => $minute,
      hour                 => $hour,
      nocheck              => $nocheck,
      mailto               => $mailto,
      mail_only_on_changes => $mail_only_on_changes,
      conf_path            => $conf_path,
      require              => Package[$package],
    }

  -> class { '::aide::config':
    conf_path               => $conf_path,
    db_path                 => $db_path,
    db_temp_path            => $db_temp_path,
    gzip_dbout              => $gzip_dbout,
    aide_log                => $aide_log,
    syslogout               => $syslogout,
    report_ignore_e2fsattrs => $report_ignore_e2fsattrs,
    config_template         => $config_template,
    require                 => Package[$package],
  }

  ~> class  { '::aide::firstrun':
    aide_path    => $aide_path,
    conf_path    => $conf_path,
    db_temp_path => $db_temp_path,
    db_path      => $db_path,
    init_timeout => $init_timeout,
    require      => Package[$package],
  }
}
