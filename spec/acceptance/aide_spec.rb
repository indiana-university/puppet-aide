require 'spec_helper_acceptance'

describe 'apply aide' do
  let(:pp) do
    <<-MANIFEST
      include aide
    MANIFEST
  end

  it 'applies idempotently' do
    idempotent_apply(pp)
  end

  describe 'aide' do
    it { is_expected.to contain_class('aide') }
    it { is_expected.to contain_class('aide::cron') }
    it { is_expected.to contain_class('aide::config') }
    it { is_expected.to contain_class('aide::firstrun') }
    it { is_expected.to contain_package('aide') }
  end
end
