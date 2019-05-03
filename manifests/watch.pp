# Copyright © 2019 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause  
#
#@summary This defines a path/rule combination in the aide.conf file
#
# @example
#   aide::watch { 'namevar': }
define aide::watch (
  $path  = $name,
  $type  = 'regular',
  $rules = undef,
  $order = 50,
) {

  include aide

  $_rules = any2array($rules)
  $_type  = downcase($type)

  validate_absolute_path($path)

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
