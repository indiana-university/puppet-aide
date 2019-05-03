require 'spec_helper'

describe 'aide' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('aide') }
      it { is_expected.to contain_package('aide').with_ensure('latest') }
      it { is_expected.to contain_class('aide::cron').that_requires('Package[aide]') }
      it { is_expected.to contain_class('aide::config').that_requires('Package[aide]') }
      it { is_expected.to contain_class('aide::firstrun').that_requires('Package[aide]') }
    end
  end
end
