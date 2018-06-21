Puppet::Type.newtype(:fm_gsub) do
  @doc = "Global find and replace"

  ensurable do
    desc "replace or delete the requested regexp from the file"
    defaultvalues
    defaultto(:present)
  end

  newparam(:path,  :namevar => :true) do
    desc "The file to operate on - you can only prepend once to any given file"
    isrequired
  end

  newparam(:data) do
    desc "replacement data for matches. If \n present newlines will be inserted"
    isrequired
  end

  newparam(:match, :namevar => :true) do
    desc "Target regexp to search for"
    isrequired

    defaultto false
  end

  newparam(:flags) do
    desc "Regexp flags"

    defaultto do
      nil
    end
  end

  # require any puppet native file resource of the same path first
  autorequire :file do
    [ self[:path] ]
  end

  def self.title_patterns
    [
        [ /(^(.*)$)/m,
          [ [:path] ] ],
    ]
    end
end
