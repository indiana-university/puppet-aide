# Changelog

## Release 1.3.5

**Enhancements**

* Updated pdk
* Added puppet aide task to initialize and copy aide database

## Release 1.2.5

**Enhancements**

* Added `report_ignore_e2fsattrs` support
* Updated README
* Added github badges

## Release 1.1.5

**Enhancements**

* Fixed deprecated `validate_legacy` warnings and switched from using params to hiera
* Added `nice` and `ionice` to throttle I/O and CPU load of AIDE
* Added unit test for `util-linux` package
* Added path to `aide init` exec command in `firstrun.pp`
* Update pdk to latest version

## Release 1.0.5

**Bugfixes**

* Pass correct variable to `mail_only_on_changes`
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
