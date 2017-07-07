require 'spec_helper'
describe 'debian_bind' do
  context 'with default values for all parameters' do
    it { should contain_class('debian_bind') }
  end
end
