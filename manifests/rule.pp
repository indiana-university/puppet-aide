# Copyright © 2019 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause  
#
#@summary This defines a rule that should be included in the aide.conf file.
#
# @example
#   aide::rule { 'namevar': }
define aide::rule (
  $rules,
  String $order = '03',
) {
  include aide

  $_rules = any2array($rules)

  concat::fragment { $name:
    target  => 'aide.conf',
    order   => $order,
    content => inline_template("${name} = <%= @_rules.join('+') %>\n"),
  }
}
