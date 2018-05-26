require 'puppet_x'
require 'puppet_x/filemagic'
Puppet::Type.type(:fm_gsub).provide(:ruby) do
  def exists?
    check_type = if @resource['ensure'] == :absent
                   :absent
                 else
                   :replace
                 end
    PuppetX::FileMagic::regex_exists?(@resource['path'], @resource['match'], @resource['flags'], check_type)
  end

  def create
    PuppetX::FileMagic::gsub_match(@resource['path'], @resource['match'], @resource['flags'], @resource['data'])
  end

  def destroy
    PuppetX::FileMagic::gsub_match(@resource['path'], @resource['match'], @resource['flags'], '')
  end
end
