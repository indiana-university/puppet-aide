# Copyright © 2022 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause
#
#@summary This class manages the aide's cron job. For all params reference README.
#
#@param aide_path
#@param cat_path
#@param rm_path
#@param mail_path
#@param conf_path
#@param minute
#@param hour
#@param nocheck
#@param mailto
#@param mail_only_on_changes
#
# @example
#   include aide::cron
class aide::cron (
  String $aide_path,
  String $cat_path,
  String $rm_path,
  String $mail_path,
  String $conf_path,
  Integer $minute,
  Integer $hour,
  Integer $nocheck,
  String $mailto,
  Boolean $mail_only_on_changes,
) {
  # Throttle I/O with nice and ionice
  $io = 'nice ionice -c3'

  if $nocheck == true {
    $cron_ensure = 'absent'
  } else {
    $cron_ensure = 'present'
  }

  if $mailto != undef {
    $settings = "${aide_path} --config ${conf_path} --check"
    $email_subject = "\"\$(hostname) - AIDE Integrity Check\" ${mailto}"
    if $mail_only_on_changes {
      cron::job { 'aide' :
        ensure  => $cron_ensure,
        command => "AIDE_OUT=$(${io} ${settings} 2>&1) || echo \"\${AIDE_OUT}\" | ${cat_path} -v | ${mail_path} -E -s ${email_subject}",
        user    => 'root',
        hour    => $hour,
        minute  => $minute,
      }
    } else {
      cron::job { 'aide':
        ensure  => $cron_ensure,
        command => "${io} ${settings} | ${cat_path} -v | ${mail_path} -s ${email_subject}",
        user    => 'root',
        hour    => $hour,
        minute  => $minute,
      }
    }
  } else {
    cron::job { 'aide':
      ensure  => $cron_ensure,
      command => "${io} ${aide_path} --config ${conf_path} --check",
      user    => 'root',
      hour    => $hour,
      minute  => $minute,
    }
  }
}
