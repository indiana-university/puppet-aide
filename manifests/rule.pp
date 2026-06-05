# Copyright © 2022 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause
#
# @summary Defines a named rule group in aide.conf (e.g. "MYRULE = p+i+n").
#
# @param rules
#   One or more AIDE attribute flags to combine into the rule.
# @param order
#   Concat fragment order used to position the rule in aide.conf.
#
# @example Declare in Puppet code
#   aide::rule { 'MYRULE':
#     rules => ['p', 'i', 'n'],
#   }
#
# @example Declare via Hiera (key aide::rule, managed automatically by the aide class)
#   aide::rule:
#     MYRULE:
#       rules:
#         - p
#         - i
#         - n
#     PERMS:
#       rules:
#         - p
#         - u
#         - g
#       order: '04'
#
define aide::rule (
  Optional[Variant[Array, String]] $rules = undef,
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
