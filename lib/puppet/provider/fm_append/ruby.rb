require 'puppet_x'
require 'puppet_x/filemagic'
Puppet::Type.type(:fm_append).provide(:ruby) do
  def exists?
    PuppetX::FileMagic::exists?(@resource['path'], @resource['data'], +1)
  end

  def create
    PuppetX::FileMagic::append(@resource['path'], @resource['data'])
  end

  def destroy
    PuppetX::FileMagic::unappend(@resource['path'], @resource['data'])
  end
end
