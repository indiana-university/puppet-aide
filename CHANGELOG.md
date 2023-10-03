# Changelog

## Release 2.2.1

**Enahncements**

* Merge pull request to update metadata dependencies (canihavethisone)
* Update changelong and metadata

## Release 2.2.0

**Enhancements**

* Merge pull request to move the cron command to a script (rstuart-indue)
* Update PDK
* Update metadata

## Release 2.1.0

**Enhancements**

* Added day, month and day of week option to cron job [#12](https://github.com/indiana-university/puppet-aide/pull/12) ([bschonec](https://github.com/bschonec))
* Added parameter to suppress the `--config /etc/aide.conf` argument in the cron job [#14](https://github.com/indiana-university/puppet-aide/pull/14) ([bschonec](https://github.com/bschonec))
* Added max_mail_lines feature [#15](https://github.com/indiana-university/puppet-aide/pull/15) ([olifre](https://github.com/olifre))
* Updated pdk
* Removed support for Debian 9
* Added unit test for day, month and day of week option


## Release 2.0.0

**Enhancements**

* Added ordering option [#8](https://github.com/indiana-university/puppet-aide/pull/8) ([brentclark](https://github.com/brentclark))
* Updated pdk
* Dropped Ubuntu 16.04 support
* Added Ubuntu 20.04 support
* Dropped support for Debian 7 and 8
* Added support for Debian 9 and 10
* Dropped support for RedHat 6
* Added support for RedHat 8
* Dropped support for Centos 6 and 7
* Added support for Centos 8 and 9
* Fixed puppet-lint validation issues
* Added acceptance test

## Release 1.3.5

**Enhancements**

* Updated pdk
* Added puppet aide task to initialize and copy aide database

## Release 1.2.5

**Enhancements**

* Added `report_ignore_e2fsattrs` support [#7](https://github.com/indiana-university/puppet-aide/pull/7) ([olifre](https://github.com/olifre))
* Updated README
* Added github badges

## Release 1.1.5

**Enhancements**

* Fixed deprecated `validate_legacy` warnings and switched from using params to hiera [#6](https://github.com/indiana-university/puppet-aide/pull/6) ([cheyngoodman ](https://github.com/cheyngoodman))
* Added `nice` and `ionice` to throttle I/O and CPU load of AIDE  [#5](https://github.com/indiana-university/puppet-aide/pull/7) ([olifre](https://github.com/olifre))
* Added unit test for `util-linux` package
* Added path to `aide init` exec command in `firstrun.pp`
* Update pdk to latest version

## Release 1.0.5

**Bugfixes**

* Pass correct variable to `mail_only_on_changes` [#3](https://github.com/indiana-university/puppet-aide/pull/3) ([twem](https://github.com/twem))
* Updated pdk

## Release 1.0.4

**Bugfixes**

* Updated pdk
* Updated dependency upbound limit


## Release 1.0.3

**Bugfixes**

* Fixed cron job command by removing support for temporary file used by mail_only_on_changes param
* Added `cat -v` to mail_only_on_changes needed to escape filenames with non-printable characters.
* Added path for mail program

## Release 1.0.2

**Bugfixes**

* Fixed changes made in release 1.0.1 which prevented aide from triggering changes due to config error.

## Release 1.0.1

* Fixed spacing in user defined rules in config template and module versioning.

## Release 1.0.0

**Features**

**Bugfixes**

**Known Issues**
