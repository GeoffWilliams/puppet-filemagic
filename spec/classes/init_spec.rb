require 'spec_helper'
describe 'filemagic' do
  context 'with default values for all parameters' do
    it { should contain_class('filemagic') }
  end
end
