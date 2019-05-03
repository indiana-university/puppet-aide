# Copyright © 2019 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause 
#
#  This will install aide and do initial db creation but disable the cron job
node default {
  class { 'aide':
    nocheck => true,
  }
  aide::rule { 'MyRule':
    rules => [ 'p', ],
  }
  aide::watch { '/etc':
    path  => '/etc',
    rules => 'MyRule'
  }
}
