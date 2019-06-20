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
        command => "LOG=$(mktemp) && ${settings} > \$LOG 2>&1 || ${cat_path} -v \$LOG | ${mail_path} -E -s ${email_subject}; ${rm_path} -f \$LOG",
        user    => 'root',
        hour    => $hour,
        minute  => $minute,
      }
    } else {
      cron::job { 'aide':
        ensure  => $cron_ensure,
        command => "${settings} | ${mail_path} -s ${email_subject}",
        user    => 'root',
        hour    => $hour,
        minute  => $minute,
      }
    }
  } else {
    cron::job { 'aide':
      ensure  => $cron_ensure,
      command => "${aide_path} --config ${conf_path} --check",
      user    => 'root',
      hour    => $hour,
      minute  => $minute,
    }
  }
}
