Puppet::Type.newtype(:fm_replace) do
  @doc = "Replace one instance of /regex/ in a text file with `data` and remove all other instances"

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

  newparam(:match) do
    desc "If specified, remove all instances of /match/, and insert one line `data` if ensure=>present"
    isrequired

    defaultto false
  end

  # require any puppet native file resource of the same path first
  autorequire :file do
    [ self[:path] ]
  end

end
