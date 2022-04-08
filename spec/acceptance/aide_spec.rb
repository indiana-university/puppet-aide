require 'spec_helper_acceptance'

describe 'apply aide' do
  let(:pp) do
    <<-MANIFEST
      include aide
    MANIFEST
  end

  it 'applies idempotently' do
    if host_inventory['facter']['os']['name'] == 'CentOS'
      run_shell('yum install cronie -y')
    end
    idempotent_apply(pp)
  end
end
