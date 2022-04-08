# Copyright © 2022 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause  
#
#@summary This defines a rule that should be included in the aide.conf file.
#
#@param rules defines the aide rules to be setup
#@param order defines the order of applying the rules
#
# @example
#   aide::rule { 'namevar': }
define aide::rule (
  Optional[Variant[Array, String]] $rules,
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
