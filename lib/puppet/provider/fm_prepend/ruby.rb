require 'puppet_x'
require 'puppet_x/filemagic'
Puppet::Type.type(:fm_prepend).provide(:ruby) do
  desc "default provider"
  def exists?
    PuppetX::FileMagic::exists?(@resource['path'], @resource['data'], @resource['match_end'], @resource['flags'], :prepend, (@resource['ensure'] == :absent))
  end

  def create
    PuppetX::FileMagic::prepend(@resource['path'], @resource['match_end'], @resource['flags'], @resource['data'], false)
  end

  def destroy
    PuppetX::FileMagic::prepend(@resource['path'], @resource['match_end'], @resource['flags'], @resource['data'], true)
  end
end
