require 'spec_helper'

describe 'aide::cron' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:settings) { '/usr/bin/aide --config /etc/aide/aide.conf --check' }
      let(:email_subject) { 'testserver - AIDE Integrity Check aide@edu' }
      let(:io) { 'nice ionice -c3' }
      let(:cron_ensure) { 'present' }
      let(:params) do
        {
          'aide_path'            => '/usr/bin/aide',
          'cat_path'             => '/bin/cat',
          'rm_path'              => '/bin/rm',
          'mail_path'            => '/usr/bin/mail',
          'conf_path'            => '/etc/aide/aide.conf',
          'minute'               => 0,
          'hour'                 => 0,
          'date'                 => '*',
          'month'                => '*',
          'weekday'              => '*',
          'nocheck'              => false,
          'mailto'               => 'aide@edu',
          'mail_only_on_changes' => false,
        }
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('aide::cron') }
      it { expect(cron_ensure).to eq('present') }
      it { expect(settings).to eq('/usr/bin/aide --config /etc/aide/aide.conf --check') }
      it { expect(email_subject).to eq('testserver - AIDE Integrity Check aide@edu') }
      it { expect(io).to eq('nice ionice -c3') }
      it { is_expected.to contain_cron__job('aide') }
    end
  end
end
