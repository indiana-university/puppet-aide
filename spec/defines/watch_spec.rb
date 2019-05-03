require 'spec_helper'

describe 'aide::watch' do
  let(:title) { 'namevar' }
  let(:params) do
    {
      'path'  => '/etc',
      'type'  => 'regular',
      'rules' => 'NORMAL',
      'order' => 50,
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:pre_condition) { 'include aide' }

      it { is_expected.to compile.with_all_deps }
    end
  end
end
