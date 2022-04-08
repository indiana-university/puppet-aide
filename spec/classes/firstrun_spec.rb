require 'spec_helper'

describe 'aide::firstrun' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { "concat { 'aide.conf': path  => '/etc/aide/aide.conf' }" }
      let(:params) do
        {
          'aide_path'     => '/usr/bin/aide',
          'conf_path'     => '/etc/aide/aide.conf',
          'db_temp_path'  => '/var/lib/aide/aide.db.new',
          'db_path'       => '/var/lib/aide/aide.db',
          'init_timeout'  => 300,
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('aide::firstrun') }
      it { is_expected.to contain_exec('aide init').that_subscribes_to('Concat[aide.conf]') }
      it { is_expected.to contain_exec('install aide db').that_subscribes_to('Exec[aide init]') }
      it { is_expected.to contain_file('/var/lib/aide/aide.db').that_requires('Exec[install aide db]') }
      it { is_expected.to contain_file('/var/lib/aide/aide.db.new').that_requires('Exec[aide init]') }
    end
  end
end
