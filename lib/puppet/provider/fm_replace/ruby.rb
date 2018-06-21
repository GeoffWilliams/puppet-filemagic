require 'puppet_x'
require 'puppet_x/filemagic'
Puppet::Type.type(:fm_replace).provide(:ruby) do
  def exists?
    check_type = if @resource['insert_if_missing']
                   :replace_insert
                 else
                   :replace
                 end

    PuppetX::FileMagic::exists?(@resource['path'], @resource['data'], @resource['match'], @resource['flags'], check_type, (@resource['ensure'] == :absent))
  end

  def create
    PuppetX::FileMagic::replace_match(@resource['path'], @resource['match'], @resource['flags'], @resource['data'], @resource['insert_if_missing'])
  end

  def destroy
    PuppetX::FileMagic::remove_match(@resource['path'], @resource['match'], @resource['flags'])
  end
end
