require 'puppet_x'
module PuppetX
  module FileMagic

    # read the first line of file to determine it's line endings
    def self.determine_line_ending(path)
      File.open(path, 'r') do |file|
        return file.readline[/\r?\n$/]
      end
    end


    def self.data2lines(data)
      if data.nil? || data.empty?
        lines = []
      else
        # support windows by chomping (CR)LF for comparison purposes
        lines = data.split(/\r?\n/)
      end

      lines
    end

    # read a text file and get rid of newlines
    def self.readfile(path)
      if File.exists?(path)
        file_lines = File.readlines(path).each {|l| l.chomp!}
      else
        Puppet.error("FileMagic unable to find file at #{path} - make sure it exists")
        file_lines = []
      end
      file_lines
    end

    # return the index of the first/last match of `regex` in `lines` or -1 if no
    # match.  Be careful with if statements using this!  It's very possible that
    # 0 will be returned to indicate a match in the first element of the array
    # which is of course false
    # @param lines data to search
    # @param regex regex to match
    # @param first match the first instance? otherwise match the last
    def self.get_match_regex(lines, regex, flags, first, data_lines)
      found_at = -1

      if regex
        # parse the string from puppet into a real ruby regex. Flags have to be separate for this
        _regex = Regexp.new(regex, flags)
        i = 0

        if ! first
          lines = lines.reverse
          data_lines = data_lines.reverse
        end

        while found_at == -1 && i < lines.size

          if _regex.match?(lines[i])
            # ignore matches that exactly match the data to be replaced to avoid getting stuck in a
            # rewriting loop every puppet run (eg match `^(no)?compress`, data `compress`)
            # check every line from here on in for exact match against data - if we get one
            # then we didn't match...
            j = 0
            lines_matched = 0
            while found_at == -1 and j < data_lines.size
              if lines[i+j] == data_lines[j]
                lines_matched += 1
              end
              j += 1
            end

            # See if we got a 100% match after doing the full scan
            if lines_matched != data_lines.size || data_lines.size == 0
              found_at = i
            end

          end
          i += 1
        end

        if !first && found_at > -1
          # need to correct the index since we reversed the array we searched
          #
          # `V` points to the element we want in the array of `X`s
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

    # Return a count of matching lines from the file
    # @param pos -1 match from beginning, 0 match from anywhere, 1 match fom end
    # @return -1 if all lines matched in correct order otherwise count of matching lines
    def self.get_match_lines(file_lines, data_lines, pos)
      exact_lines_matched = 0

      # use a separate variable for file_lines to do exact vs partial match as we must
      # start matching a different points for each test

      if pos == 1
        # reverse match order if we are checking the end of the file
        data_lines = data_lines.reverse
        file_lines_exact = file_lines.reverse if file_lines
      elsif pos == 0 and data_lines.size > 0
        # scan through `file_lines` to find the fist line from data_lines and start there (or nowhere if its not found)
        index = file_lines.find_index(data_lines[0]) || [file_lines.size() -1, 0].max
        file_lines_exact = file_lines[index, data_lines.size]
      else
        file_lines_exact = file_lines
      end

      # check-off that each line in our data is already in the file, in the exact correct position
      # and short-circuit if file is too short to possibly match
      i = 0
      while file_lines_exact.size >= data_lines.size && i < data_lines.size
        data_line = data_lines[i]
        file_line = file_lines_exact[i]

        if file_line == data_line
          exact_lines_matched += 1
        end

        i += 1
      end

      if exact_lines_matched == data_lines.size and data_lines.size > 0
        # -1 indicates all lines matched
        lines_matched = -1
      else
        partial_matches = 0
        file_lines.each { |file_line|
          data_lines.each { |data_line|
            if file_line == data_line
              partial_matches += 1
            end
          }
        }
        lines_matched = partial_matches
      end

      lines_matched
    end

    # sandwich position not implemented yet
    # -1 TOP OF file
    # 0 SANDWICH
    # +1 END OF FILE
    # @param path File to inspect
    # @param data Lines of data to look for.  If (CR)LF character found, newlines
    #   will be inserted or you can just pass an array
    # @param regex Regular expression to match or false to skip
    # @param position Where to look for a match - -1 top of file, 0 sandwich,
    #   +1 bottom of file
    # @param check_type what kind of check are we doing?  :present, :absent
    def self.exists?(path, data, regex, flags, check_type, check_for_absent)
      data_lines = data2lines(data)
      if ! check_for_absent && data_lines.size == 0
        raise "you must supply a valid string of `data` to check for"
      end

      if ! File.exist?(path)
        Puppet.err("File missing at #{path} (file must already exist to do filemagic on it...)")

        # cannot possibly exist if it doesn't exist
        exists = false
      else
        file_lines = readfile(path)
        case check_type
        when :append, :prepend
          # Check for an exact match on `data` at the beginning or end of file
          pos = if check_type == :prepend
                  -1
                else
                  1
                end
          all_lines_matched = (get_match_lines(file_lines, data_lines, pos) == -1)

          if ! all_lines_matched
            # if all lines didn't match there might me a regex we need to scan for
            if regex
              partial_match = (get_match_regex(file_lines, regex, flags, true, data_lines) > -1)
            end

            # Nothing found by regex.. last check - do we have a partial match on any data?
            if ! partial_match
              partial_match = (get_match_lines(file_lines, data_lines, pos) > 0)
            end
          else
            partial_match = false
          end

          if all_lines_matched
            exists = true
          elsif partial_match
            exists = check_for_absent
          else
            exists = false
          end


        when :gsub
          exists =
              if (get_match_regex(file_lines, regex, flags, true, data_lines) > -1)
                check_for_absent
              else
                ! check_for_absent
              end
        when :replace, :replace_insert
          # If we find `regex` anywhere in file we need to fire (ensure=>present --> exists=false)
          match_count = get_match_regex(file_lines, regex, flags, true, data_lines)

          if match_count == -1

            if check_for_absent
              # detect exact or partial match on data that needs to be removed
              exists = (get_match_lines(file_lines, data_lines, 0) != 0)
            elsif check_type == :replace_insert
              # detect full match against data
              exists = (get_match_lines(file_lines, data_lines, 0) == -1)
            else
              # we 'exist' because all necessary replacements have been made
              exists = true
            end
          else
            exists = check_for_absent
          end
        else
          raise "Unsupported check type #{check_type}"
        end
      end

      exists
    end

    def self.prepend(path, regex_end, flags, data)
      # read the old content into an array and prepend the required lines
      content = readfile(path)
      found_at = get_match_regex(content, regex_end, flags, false, data2lines(data))
      if found_at > -1
        # Discard from the beginning of the file all lines before and including content[found_at]
        content = content[found_at+1..content.size-1]
      end

      # insert the lines at the start of the file
      content.unshift(data2lines(data))

      # write the new content in one go
      File.open(path, "w") do |f|
        f.puts(content)
      end
    end

    def self.unprepend(path, regex_end, flags, data)
      # read the old content into an array and remove the required lines
      content = readfile(path)
      found_at = get_match_regex(content, regex_end, flags,false, data2lines(data))
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
      File.open(path, "w") do |f|
        f.puts(content)
      end
    end

    def self.append(path, regex_start, flags, data)
      # write the new content in one go
      content = readfile(path)
      found_at = get_match_regex(content, regex_start, flags,true, data2lines(data))

      if found_at > -1
        # Discard from the end of the file all lines including and after content[found_at]
        content = content[0..found_at-1]
      end

      # perform the append
      content += data2lines(data)

      File.open(path, "w") do |f|
        f.puts(content)
      end
    end

    def self.unappend(path, regex_start, flags, data)
      content = readfile(path)
      found_at = get_match_regex(content, regex_start, flags, true, data2lines(data))
      if found_at > -1
        # Delete based on regexp (match)
        #
        # Discard from the end of the file all lines including and after content[found_at]
        content = content[0..found_at-1]
      else
        # Delete based on exact match for `data`
        lines = data2lines(data)
        if lines
          data2lines(data).reverse.each { |line|
            if content[-1].strip == line.strip
              content.pop
            end
          }
        end
      end
      # write the new content in one go
      File.open(path, "w") do |f|
        f.puts(content)
      end
    end


    def self.remove_match(path, regex, flags)
      content = readfile(path).reject { |line|
        _regex = Regexp.new(regex, flags)
        _regex.match?(line)
      }
      File.open(path, "w") do |f|
        f.puts(content)
      end

    end

    def self.replace_match(path, regex, flags, data, insert_if_missing)
      content = []
      inserted = false
      found = false
      _regex = Regexp.new(regex, flags)

      readfile(path).each { |line|

        if _regex.match?(line)
          if ! inserted
            content << data
            inserted = true
          end
        else
          if line == data
            found = true
          end
          content << line
        end
      }

      if insert_if_missing && (! (found || inserted))
        content << data
      end

      File.open(path, "w") do |f|
        f.puts(content)
      end

    end

    def self.gsub_match(path, regex, flags, data)
      # Read the file and flatten it based on the FILE's encoding (not the os...)
      content = readfile(path).join(determine_line_ending(path))
      _regex = Regexp.new(regex, flags)
      content = content.gsub(_regex, data)
      File.open(path, "w") do |f|
        f.puts(content)
      end
    end

  end
end
