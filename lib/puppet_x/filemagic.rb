require 'puppet_x'
module PuppetX
  module FileMagic

    # read the first line of file to determine it's line endings
    def self.determine_line_ending(path)
      File.open(path, 'r') do |file|
        return file.readline[/\r?\n$/]
      end
    end

    # split data (string, eg: foo\n\bar\baz..) into an array of lines
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
        Puppet.err("FileMagic unable to find file at #{path} - make sure it exists")
        file_lines = []
      end
      file_lines
    end

    # (over)write the output file and print a message that we did so
    def self.writefile(path, content)
      if File.exists?(path)
        File.open(path, "w") do |f|
          f.puts(content)
        end
        Puppet.notice("FileMagic updated: #{path}")
      else
        Puppet.err("FileMagic unable to find file at #{path} - make sure it exists")
      end
    end

    # return the index of the first/last match of `regex` in `lines` or -1 if no
    # match.  Be careful with if statements using this!  It's very possible that
    # 0 will be returned to indicate a match in the first element of the array
    # which is of course false
    # @param file_lines data to search
    # @param regex regex to match
    # @param flags flags to use with this regex
    # @param first match the first instance? otherwise match the last
    def self.get_match_regex(file_lines, regex, flags, first)
      found_at = -1

      if regex
        # parse the string from puppet into a real ruby regex. Flags have to be separate for this
        _regex = Regexp.new(regex, flags)
        i = 0

        if first
          file_lines_ordered = file_lines
        else
          file_lines_ordered = file_lines.reverse
        end

        while found_at == -1 && i < file_lines_ordered.size
          file_line = file_lines_ordered[i]

          # only interested in the the first line of data
          if _regex.match?(file_line)
            found_at = i
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
          found_at = file_lines_ordered.size - found_at - 1
        end
      end

      found_at
    end

    # Return a count of matching lines from the file and an array of lines representing the contents of the file less
    # any matches. the `pos` parameter can be used to anchor the search to the beginning or end of the file if desired.
    # @param pos -1 match from beginning, 0 match from anywhere, 1 match fom end
    # @return tuple, element 0: -1 if all lines matched in correct order otherwise count of matching lines
    #   element 1: the file lines less the exact match
    def self.get_match_lines(file_lines, data_lines, pos)
      exact_lines_matched = 0
      file_lines_less_exact_match = []

      if pos == 1
        # reverse match order if we are checking the end of the file
        data_lines_ordered = data_lines.reverse if data_lines
        file_lines_ordered = file_lines.reverse if file_lines
      else
        file_lines_ordered = file_lines
        data_lines_ordered = data_lines
      end

      # we need different indices for file_line vs data_line when we are searching with pos=0 since our data_lines are
      # allowed to exist _anywhere_ in the input data
      i = 0
      j = 0
      while file_lines_ordered.size && i < file_lines_ordered.size
        file_line = file_lines_ordered[i]
        data_line = data_lines_ordered[j]

        # check-off that each line in our data is already in the file, in the exact correct position
        line_matched = (file_line == data_line)

        #
        # indicies for next loop
        #
        i += 1
        if (pos != 0)
          j = [i, data_lines_ordered.size].min
        elsif line_matched
          # we have matched data_lines inside file lines _and_ we are matching from anywhere so we have found the
          # start of the match, start incrementing `j` until we run out of lines / matches
          j = [j += 1, data_lines_ordered.size].min
        end

        # evaluate our current match, automatically taking account of position in file_lines due to our loop position
        if line_matched
          exact_lines_matched += 1
        else
          file_lines_less_exact_match.push(file_line)
        end

      end

      if (exact_lines_matched == data_lines_ordered.size) && (data_lines_ordered.size > 0)
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

      if pos == 1
        # If we matched from the end the matched lines will be reversed - fix this in-place
        file_lines_less_exact_match.reverse!
      end

      return lines_matched, file_lines_less_exact_match
    end

    # sandwich position not implemented yet
    # -1 TOP OF file
    # 0 SANDWICH
    # +1 END OF FILE
    # @param path File to inspect
    # @param data Lines of data to look for.  If (CR)LF character found, newlines
    #   will be inserted or you can just pass an array
    # @param regex Regular expression to match or false to skip
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
          pos = (check_type == :prepend) ? -1 : 1
          lines_matched, file_lines_less_exact_match = get_match_lines(file_lines, data_lines, pos)
          all_lines_matched = (lines_matched == -1)

          if all_lines_matched
            exists = true
          else
            # if all lines didn't match there might me a regex we need to scan for
            if regex
              partial_match = (get_match_regex(file_lines_less_exact_match, regex, flags, true) > -1)
            end

            # Nothing found by regex.. last check - do we have a partial match on any data?
            if ! partial_match
              partial_match = (get_match_lines(file_lines_less_exact_match, data_lines, pos)[0] > 0)
            end

            exists = check_for_absent && partial_match
          end

        when :gsub
          exists =
              if (get_match_regex(file_lines, regex, flags, true) > -1)
                check_for_absent
              else
                ! check_for_absent
              end
        when :replace, :replace_insert
          # check for a 100% match on `data_lines` in `files_lines`, anywhere in the file
          matched_lines, file_lines_less_exact_match = get_match_lines(file_lines, data_lines, 0)
          all_lines_matched = (matched_lines == -1)

          # Also do a regex search on the file less any exact match, that we me check for any unwanted instances of
          # `match` that still exist in the file ("stragglers")
          match_count = get_match_regex(file_lines_less_exact_match, regex, flags, true)
          if all_lines_matched
            if match_count > -1
              # we have a straggler - force the correct update for ensure present/absent
              exists = check_for_absent
            else
              exists = all_lines_matched
            end
          elsif check_type == :replace_insert
            # `data_lines` were not matched but they are supposed to exist
            exists = false
          else
            # matches were found in check_for_absent mode means we need to remove them, otherwise we exist (aka dont
            # need processing) if there are _no_ matches
            exists = check_for_absent ^ (match_count == -1)
          end
        else
          raise "Unsupported check type #{check_type}"
        end
      end

      exists
    end

    def self.prepend(path, regex_end, flags, data, delete)
      # read the old content into an array and prepend the required lines
      content = readfile(path)
      found_at = get_match_regex(content, regex_end, flags, false)
      data_lines = data2lines(data)

      if found_at > -1
        # Discard from the beginning of the file all lines before and including content[found_at]
        content = content[found_at+1..content.size-1]
      end

      if delete
        # If we deleted based on the match, then target is already gone, otherwise if we are removing
        # based on `data` remove any lines line
        data_lines.each { |line|
          if content[0] == line
            content.shift
          end
        }
      else
        # insert the lines at the start of the file
        content.unshift(data_lines)
      end

      # write the new content in one go
      writefile(path, content)
    end


    def self.append(path, regex_start, flags, data, delete)
      # write the new content in one go
      content = readfile(path)
      found_at = get_match_regex(content, regex_start, flags,true)
      data_lines = data2lines(data)

      if found_at > -1
        # Discard from the end of the file all lines including and after content[found_at]
        content = content[0..found_at-1]
      end

      if delete
        data_lines.reverse.each { |line|
          if content[-1].strip == line.strip
            content.pop
          end
        }
      else
        content += data_lines
      end

      writefile(path, content)
    end


    def self.remove_match(path, regex, flags)
      content = readfile(path).reject { |line|
        _regex = Regexp.new(regex, flags)
        _regex.match?(line)
      }
      writefile(path, content)
    end

    def self.replace_match(path, regex, flags, data, insert_if_missing, insert_at)
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
        case insert_at
        when 'top'
          insertion_point = 0
        when 'bottom'
          insertion_point = content.size
        else
          line_no = Integer(insert_at)
          if line_no > content.size
            Puppet.warning(
                "#{path}: Cannot insert line #{line_no}, only #{content.size} lines in file")
            insertion_point = content.size
          else
            insertion_point = line_no
          end
        end
        content.insert(insertion_point, data)
      end

      writefile(path, content)
    end

    def self.gsub_match(path, regex, flags, data)
      # Read the file and flatten it based on the FILE's encoding (not the os...)
      content = readfile(path).join(determine_line_ending(path))
      _regex = Regexp.new(regex, flags)
      content = content.gsub(_regex, data)
      writefile(path, content)
    end

  end
end
