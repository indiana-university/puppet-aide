# Copyright © 2022 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause
#
# @summary Defines a path/rule combination in aide.conf.
#
# @param path
#   Absolute path of the file or directory to watch. Defaults to the resource title.
# @param type
#   How the path is matched: 'regular' (prefix), 'equals' (exact), or 'exclude' (ignored).
# @param rules
#   One or more AIDE rule names or attribute flags to apply to the path.
# @param order
#   Concat fragment order used to position the entry in aide.conf.
#
# @example Declare in Puppet code
#   aide::watch { '/etc':
#     rules => ['NORMAL'],
#   }
#
# @example Declare via Hiera (key aide::watch, managed automatically by the aide class)
#   aide::watch:
#     /etc:
#       rules:
#         - NORMAL
#     /var/log:
#       rules:
#         - LOG
#       type: regular
#     /tmp:
#       type: exclude
#
define aide::watch (
  Stdlib::Absolutepath $path = $name,
  String $type  = 'regular',
  Optional[Variant[Array, String]] $rules = undef,
  Integer $order = 50,
) {
  include aide

  $_rules = any2array($rules)
  $_type  = downcase($type)

  $content = $_type ? {
    'regular' => inline_template("${path} <%= @_rules.join('+') %>\n"),
    'equals'  => inline_template("=${path} <%= @_rules.join('+') %>\n"),
    'exclude' => inline_template("!${path}\n"),
    default   => fail("Type field value ${type} is invalid.  Acceptable values are ['regular', 'equals', 'exclude']"),
  }

  # Try to ensure that exclude watches are defined prior to actual watches (can override)
  case $_type {
    'exclude': { $watch_order = $order + 20 }
    default:   { $watch_order = $order }
  }

  concat::fragment { $title:
    target  => 'aide.conf',
    order   => $watch_order,
    content => $content,
  }
}
