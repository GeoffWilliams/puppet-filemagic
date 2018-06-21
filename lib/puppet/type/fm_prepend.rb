Puppet::Type.newtype(:fm_prepend) do
  @doc = "Prepend lines to a text file"

  ensurable do
    desc "Add or remove the requested lines from the file"
    defaultvalues
    defaultto(:present)
  end

  newparam(:path,  :namevar => :true) do
    desc "The file to operate on - you can only prepend once to any given file"
    isrequired
  end

  newparam(:data) do
    desc "Lines to add to the file - accepts string or array.  If \n present newlines will be inserted"
    isrequired
  end

  newparam(:match_end) do
    desc "If specified, remove the line matching this regexp and all previous lines, then prepend `data`"
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

end
