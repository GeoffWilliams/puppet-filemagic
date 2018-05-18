require 'puppet_x'
require 'puppet_x/filemagic'
Puppet::Type.type(:fm_replace).provide(:ruby) do
  def exists?
    check_type = if @resource['ensure'] == :absent
                   :absent
                 else
                   :replace
                 end
    PuppetX::FileMagic::exists?(@resource['path'], @resource['data'], @resource['match'], -1, @resource['ensure'])
  end

  def create
    PuppetX::FileMagic::replace_match(@resource['path'], @resource['match'], @resource['data'])
  end

  def destroy
    PuppetX::FileMagic::remove_match(@resource['path'], @resource['match'])
  end
end
