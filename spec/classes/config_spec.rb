require 'spec_helper'

describe 'aide::config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) do
        {
          'conf_path'               => '/etc/aide/aide.conf',
          'db_path'                 => '/var/lib/aide/aide.db',
          'db_temp_path'            => '/var/lib/aide/aide.db.new',
          'gzip_dbout'              => false,
          'aide_log'                => '/var/log/aide/aide.log',
          'syslogout'               => true,
          'report_ignore_e2fsattrs' => :undef,
          'config_template'         => 'aide/aide.conf.erb',
        }
      end

      it { is_expected.to compile.with_all_deps }
      it {
        is_expected.to contain_concat('aide.conf').with(
          'path'  => '/etc/aide/aide.conf',
          'owner' => 'root',
          'group' => 'root',
          'mode'  => '0600',
        )
      }
      it {
        is_expected.to contain_concat__fragment('aide.conf.header').with(
          'target'  => 'aide.conf',
          'order'   => '01',
          'content' => %r{database=file:@@{DBDIR}},
        )
      }
      it {
        is_expected.to contain_concat__fragment('rule_header').with(
          'target'  => 'aide.conf',
          'order'   => '02',
          'content' => "\n# User defined rules\n",
        )
      }
      it {
        is_expected.to contain_concat__fragment('watch_header').with(
          'target'  => 'aide.conf',
          'order'   => '45',
          'content' => "\n# Files and directories to scan\n",
        )
      }
    end
  end
end
