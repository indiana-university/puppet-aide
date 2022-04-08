# Copyright © 2022 The Trustees of Indiana University
# SPDX-License-Identifier: BSD-3-Clause  
#
#@summary This defines a path/rule combination in the aide.conf file
#
#@param path specifies the path for files or directories to watch.
#@param type defines the type of watch to be used.
#@param rules defines the aide rules to be setup.
#@param order defines the order of applying the rules.
#
# @example
#   aide::watch { 'namevar': }
define aide::watch (
  Stdlib::Absolutepath $path = $name,
  String $type  = 'regular',
  Variant[Array, String] $rules = undef,
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
