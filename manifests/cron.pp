# Copyright © 2019 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause
#
#@summary This class manages the aide's cron job.
#
# @example
#   include aide::cron
class aide::cron (
  $aide_path,
  $cat_path,
  $rm_path,
  $mail_path,
  $conf_path,
  $minute,
  $hour,
  $nocheck,
  $mailto,
  $mail_only_on_changes,
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
