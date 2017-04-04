require 'puppet_x'
require 'puppet_x/filemagic'
Puppet::Type.type(:fm_prepend).provide(:ruby) do
  def exists?
    PuppetX::FileMagic::exists?(@resource['path'], @resource['data'], -1)
  end

  def create
    PuppetX::FileMagic::prepend(@resource['path'], @resource['data'])
  end

  def destroy
    PuppetX::FileMagic::unprepend(@resource['path'], @resource['data'])
  end
end
