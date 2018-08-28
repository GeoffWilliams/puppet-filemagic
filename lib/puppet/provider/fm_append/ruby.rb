require 'puppet_x'
require 'puppet_x/filemagic'
Puppet::Type.type(:fm_append).provide(:ruby) do
  desc "default provider"
  def exists?
    PuppetX::FileMagic::exists?(@resource['path'], @resource['data'], @resource['match_start'], @resource['flags'], :append, @resource['ensure'] == :absent)
  end

  def create
    PuppetX::FileMagic::append(@resource['path'], @resource['match_start'], @resource['flags'], @resource['data'], false)
  end

  def destroy
    PuppetX::FileMagic::append(@resource['path'], @resource['match_start'], @resource['flags'], @resource['data'], true)
  end
end
