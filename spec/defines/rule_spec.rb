require 'spec_helper'

describe 'aide::rule' do
  let(:title) { 'namevar' }
  let(:params) do
    {
      'rules' => ['p+i'],
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:_rules) { "[ 'p','i' ]" }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('aide') }
      it { expect(_rules).to eq("[ 'p','i' ]") }
    end
  end
end
