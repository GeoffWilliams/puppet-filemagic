Puppet::Type.newtype(:fm_replace) do
  @doc = "Replace one instance of /regex/ in a text file with `data` and remove all other instances. Note that this works
like a line-by-line find and replace. If there is nothing to replace then no change will be made! (use file_line for that)"

  ensurable do
    desc "Add or remove the requested lines from the file"
    defaultvalues
    defaultto(:present)
  end

  newparam(:path,  :namevar => :true) do
    desc "The file to operate on - you can only prepend once to any given file"
    isrequired
  end

  newparam(:data, :namevar => :true) do
    desc "Lines to add to the file - accepts string or array.  If \n present newlines will be inserted"
    isrequired
  end

  newparam(:match, :namevar => :true) do
    desc "If specified, remove all instances of /match/, and insert one line `data` if ensure=>present"
    isrequired

    defaultto false
  end

  newparam(:flags) do
    desc "Regexp flags"

    defaultto do
      nil
    end
  end

  newparam(:insert_if_missing) do
    desc "If `true`, always ensure that `data` is added to file, even if this involves inserting a new line instead of replacing a match"

    defaultto false
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
