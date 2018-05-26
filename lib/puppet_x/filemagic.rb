require 'puppet_x'
module PuppetX
  module FileMagic
    def self.data2lines(data)
      if data.class == String
        data = data.split("\n")
      end

      data
    end

    # return the index of the first/last match of `regex` in `lines` or -1 if no
    # match.  Be careful with if statements using this!  It's very possible that
    # 0 will be returned to indicate a match in the first element of the array
    # which is of course false
    # @param lines data to search
    # @param regex regex to match
    # @param first match the first instance? otherwise match the last
    def self.get_match(lines, regex, first)
      found_at = -1
      if regex
        i = 0

        if ! first
          lines = lines.reverse
        end

        while found_at == -1 and i < lines.size
          # puppet passes regex's as strings to ruby even regex is a primative
          # now.  Hands up who's suprised by that
          real_regex = Regexp.new regex
          if lines[i] =~ real_regex
            found_at = i
          end
          i += 1
        end

        if !first and found_at > -1
          # need to correct the index since we reversed the array we searched
          #
          #      V = 5
          # XXXXXXX size == 7
          #
          # want
          #
          #  V=1
          # XXXXXXX
          found_at = lines.size - found_at - 1
        end
      end
      found_at
    end

    # sandwich position not implemented yet
    # -1 TOP OF file
    # 0 SANDWICH
    # +1 END OF FILE
    # @param filename File to inspect
    # @param data Lines of data to look for.  If \n character found, newlines
    #   will be inserted or you can just pass an array
    # @param regex Regular expression to match or false to skip
    # @param position Where to look for a match - -1 top of file, 0 sandwich,
    #   +1 bottom of file
    # @param check_type what kind of check are we doing?  :present, :absent
    def self.exists?(filename, data, regex, position, check_type)
      exists = true
      data_lines = data2lines(data)

      # IO readlines keeps the newlines and IO writelines strips them - can't
      # eat its own dogfood so we need to write our own here...
      if ! File.exist?(filename)
        Puppet.err("File missing at #{filename} (file must already exist to do filemagic on it...)")
        exists = if check_type == :absent
                   false
                 else
                   true
                 end
      else
        file_lines = File.readlines(filename).each {|l| l.chomp!}

        if check_type == :absent
          found = false
          if regex and get_match(file_lines, regex, true) > -1
            found = true
          end
          
          
          file_lines.each {|l|
            if data_lines
              data_lines.each { |d|
                if l==d
                  found = true
                end
              }
            end
          }

          exists = found

        elsif check_type == :replace
          needs_replace = false
          data_lines.each { |line|
            if line =~ /#{regex}/ or line == data
              needs_replace = true
            end

            exists = exists and needs_replace
          }

        else

          # Test 1:  Exact match
          # reverse match order if we are checking the end of the file
          if position > 0
            data_lines = data_lines.reverse
            file_lines = file_lines.reverse
          end

          # check-off that each line in our data is already in the file
          i = 0
          while exists and data_lines and i < data_lines.size
            data_line = data_lines[i]
            file_line = file_lines[i]

            if file_line != data_line
              exists = false
            end
            i += 1
          end

          # Test 2 (optional): We may still exist based on the presence/absence of
          # a regex in the file.  At this point our exists? status depends on whether
          # we are being ensured :present or :absent -- if we are supposed to be
          # :present, then a regex match without an exact match means we need to
          # update the file to update it, whereas :absent means that we should clean
          # out the old value to make the file identical to if we had added new data
          # and then removed it.

          # Test 3: if the regex matches any lines in the file then we need to run
          # so that we can nuke them all and rewrite
        end
      end


      exists
    end

    def self.prepend(filename, regex_end, data)
      # read the old content into an array and prepend the required lines
      content = File.readlines(filename).each {|l| l.chomp!}
      found_at = get_match(content, regex_end, false)
      if found_at > -1
        # Discard from the beginning of the file all lines before and including content[found_at]
        content = content[found_at+1..content.size-1]
      end

      # insert the lines at the start of the file
      content.unshift(data2lines(data))

      # write the new content in one go
      File.open(filename, "w") do |f|
        f.puts(content)
      end
    end

    def self.unprepend(filename, regex_end, data)
      # read the old content into an array and remove the required lines
      content = File.readlines(filename).each {|l| l.chomp!}
      found_at = get_match(content, regex_end, false)
      if found_at > -1
        # Discard from the beginning of the file all lines before and including content[found_at]
        content = content[found_at+1..content.size-1]
      else
        # remove as many lines as we are told to
        data2lines(data).each { |line|
          # we double check that the lines read are still valid since we
          # checked with exists? to prevent possible race conditions (although
          # we could still encounter them since there's no locking)
          if content[0] == line
            content.shift
          end
        }
      end
      # write the new content in one go
      File.open(filename, "w") do |f|
        f.puts(content)
      end
    end

    def self.append(filename, regex_start, data)
      # write the new content in one go
      content = File.readlines(filename).each {|l| l.chomp!}
      found_at = get_match(content, regex_start, true)

      if found_at > -1
        # Discard from the end of the file all lines including and after content[found_at]
        content = content[0..found_at-1]
      end

      # perform the append
      content += data2lines(data)

      File.open(filename, "w") do |f|
        f.puts(content)
      end
    end

    def self.unappend(filename, regex_start, data)
      content = File.readlines(filename).each {|l| l.chomp!}
      found_at = get_match(content, regex_start, true)
      if found_at > -1
        # Discard from the end of the file all lines including and after content[found_at]
        content = content[0..found_at-1]
      else
        data2lines(data).reverse.each { |line|
          if content[-1] == line
            content.pop
          end
        }
      end
      # write the new content in one go
      File.open(filename, "w") do |f|
        f.puts(content)
      end
    end


    def self.remove_match(filename, regex)
      content = File.readlines(filename).reject { |line|
        line =~ /#{regex}/
      }
      File.open(filename, "w") do |f|
        f.puts(content)
      end

    end

    def self.replace_match(filename, regex, data)
      content = []
      matched = false
      File.readlines(filename).each { |line|
        if line =~ /#{regex}/
          if ! matched
            content << line.gsub(regex, data)
            matched = true
          end
        else
          content << line
        end
      }
      File.open(filename, "w") do |f|
        f.puts(content)
      end

    end

    def self.regex_exists?(filename, regex, flags, check_type)
      _regex = Regexp.new(regex, flags)
      found =
          if _regex.match(File.read(filename))
            true
          else
            false
          end

      exists =
          if check_type == :replace
            ! found
          elsif check_type == :absent
            found
          end


    end

    def self.gsub_match(filename, regex, flags, data)
      content = File.read(filename)
      _regex = Regexp.new(regex, flags)
      content = content.gsub(_regex, data)
      File.open(filename, "w") do |f|
        f.puts(content)
      end
    end

  end
end
