require 'puppet_x'
require 'puppet_x/filemagic'
Puppet::Type.type(:fm_prepend).provide(:ruby) do
  def exists?
    PuppetX::FileMagic::exists?(@resource['path'], @resource['data'], @resource['match_end'], -1, @resource['ensure'])
  end

  def create
    PuppetX::FileMagic::prepend(@resource['path'], @resource['match_end'], @resource['data'])
  end

  def destroy
    PuppetX::FileMagic::unprepend(@resource['path'], @resource['match_end'], @resource['data'])
  end
end
