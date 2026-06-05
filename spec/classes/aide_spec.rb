require 'spec_helper'

describe 'aide' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('aide') }
      it { is_expected.to contain_package('util-linux').with_ensure('present') }
      it { is_expected.to contain_package('aide').with_ensure('latest') }
      it { is_expected.to contain_class('aide::cron').that_requires('Package[aide]') }
      it { is_expected.to contain_class('aide::config').that_requires('Package[aide]') }
      it { is_expected.to contain_class('aide::firstrun').that_requires('Package[aide]') }

      context 'with rules declared via Hiera' do
        let(:hiera_config) { File.expand_path('spec/fixtures/hiera/hiera.yaml') }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aide__rule('MYRULE').with_rules(['p', 'i', 'n']) }
        it { is_expected.to contain_aide__rule('PERMS').with_rules(['p', 'u', 'g']).with_order('04') }
      end

      context 'with watches declared via Hiera' do
        let(:hiera_config) { File.expand_path('spec/fixtures/hiera/hiera.yaml') }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_aide__watch('/etc').with_rules(['NORMAL']) }
        it { is_expected.to contain_aide__watch('/var/log').with_rules(['LOG']).with_type('regular') }
        it { is_expected.to contain_aide__watch('/tmp').with_type('exclude') }
      end
    end
  end
end
