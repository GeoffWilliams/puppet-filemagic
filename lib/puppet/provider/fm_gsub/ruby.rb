require 'puppet_x'
require 'puppet_x/filemagic'
Puppet::Type.type(:fm_gsub).provide(:ruby) do
  def exists?
    PuppetX::FileMagic::exists?(@resource['path'], @resource['data'], @resource['match'], @resource['flags'], :gsub, (@resource['ensure'] == :absent))
  end

  def create
    PuppetX::FileMagic::gsub_match(@resource['path'], @resource['match'], @resource['flags'], @resource['data'])
  end

  def destroy
    PuppetX::FileMagic::gsub_match(@resource['path'], @resource['match'], @resource['flags'], '')
  end
end
