# Copyright © 2022 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause
#
#@summary The class manages the installation and configuration of Advanced Intrusion Detection Environment.
#
#@example
#   include aide
#
#@param package
#   AIDE package name. Default is set to aide.
#
#@param version
#   AIDE version for installation passed to Package ensure. Default is set to latest.
#
#@param conf_path
#   Location of AIDE configuration file.
#
#@param db_path
#   Location of AIDE database file.
#
#@param db_temp_path
#   Location of update AIDE database file.
#
#@param gzip_dbout
#   Gzip the AIDE database file (may affect performance). Default is set to not gzip the database file.
#
#@paramaide_path
#   Location of aide binary.
#
#@param config_template
#   Template to use for aide configuration.
#
#@param aide_log
#   AIDE check output log.
#
#@param syslogout
#   Enables logging to the system logging service AUTH facility and '/var/log/messages'.
#
#@param hour
#   Hour of cron job to run.
#
#@param minute
#   Minute of cron job to run.
#
#@param date
#   Date of cron job to run.
#
#@param month
#   Month of cron job to run.
#
#@param weekday
#   Day of week of cron job to run.
#
#@param exclude_config_argument
# Default: False
# Exclude the '--config ${conf_path}' argument from the CRON job.  This is helpful if you have
# 3rd party hardening scripts that are causing false negatives for AIDE runs.
#@param nocheck
#   Whether to enable or disable scheduled checks.
#
#@param mailto
#   Set this vaule to send email of results from aide --check in cron.
#
#@param mail_only_on_changes
#   If mail_only_on_changes is set to true,
#   mails are only sent if changes are detected by AIDE.
#   By default this flag is set to false
#
#@param init_timeout
#   Allows to adjust timeout of the "aide --init" run.
#   Puppet default exec timeout is 300 (which is also kept),
#   but this may be insufficient for more complex aide DBs.
#
#@param report_ignore_e2fsattrs
#   List (no delimiter) of ext2 file attributes which are
#   to be ignored in the final report.
#   See chattr(1) for the available attributes.
#   Use '0' to not ignore any attribute.
#   Ignored attributes are represented by a ':' in the output.
#   The default is to not ignore any ext2 file attribute.
#@param cat_path is the system cat command path.
#@param rm_path is the system rm command path.
#@param aide_path is the aide path
#@param mail_path is the aide path
class aide (
  String $package,
  String $version,
  String $conf_path,
  String $db_path,
  String $db_temp_path,
  Boolean $gzip_dbout,
  String $aide_path,
  String $mail_path,
  String $config_template,
  Optional[String] $report_ignore_e2fsattrs,
  String $aide_log,
  Boolean $syslogout,
  Boolean $nocheck,
  Optional[String] $mailto,
  Boolean $mail_only_on_changes,
  Integer $init_timeout,
  String $cat_path,
  String $rm_path,
  Cron::Minute        $minute      = '0',
  Cron::Hour          $hour        = '0',
  Cron::Date          $date        = '*',
  Cron::Month         $month       = '*',
  Cron::Weekday       $weekday     = '*',
  Boolean $exclude_config_argument = false,
) {
  # Used to throttle I/O and CPU load of AIDE.
  package { 'util-linux':
    ensure => 'present',
  }

  package { $package:
    ensure => $version,
  }

  -> class { 'aide::cron':
    aide_path               => $aide_path,
    cat_path                => $cat_path,
    rm_path                 => $rm_path,
    mail_path               => $mail_path,
    minute                  => $minute,
    hour                    => $hour,
    date                    => $date,
    month                   => $month,
    weekday                 => $weekday,
    exclude_config_argument => $exclude_config_argument,
    nocheck                 => $nocheck,
    mailto                  => $mailto,
    mail_only_on_changes    => $mail_only_on_changes,
    conf_path               => $conf_path,
    require                 => Package[$package],
  }

  -> class { 'aide::config':
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

  ~> class { 'aide::firstrun':
    aide_path    => $aide_path,
    conf_path    => $conf_path,
    db_temp_path => $db_temp_path,
    db_path      => $db_path,
    init_timeout => $init_timeout,
    require      => Package[$package],
  }
}
