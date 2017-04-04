require 'puppet_x'
module PuppetX
  module FileMagic
    def self.data2lines(data)
      data.split("\n")
    end


    # position not implemented yet
    # -1 TOP OF file
    # 0 SANDWICH
    # +1 END OF FILE
    def self.exists?(filename, data, position)
      exists = true
      data_lines = data2lines(data)

      # IO readlines keeps the newlines and IO writelines strips them - can't
      # eat its own dogfood so we need to write our own here...
      file_lines = File.readlines(filename).each {|l| l.chomp!}

      # reverse match order if we are checking the end of the file
      if position > 0
        data_lines = data_lines.reverse
        file_lines = file_lines.reverse
      end

      # check-off that each line in our data is already in the file
      i = 0
      while exists and i < data_lines.size
        data_line = data_lines[i]
        file_line = file_lines[i]

        if file_line != data_line
          exists = false
        end
        i += 1
      end

      exists
    end

    def self.prepend(filename, data)
      # read the old content into an array and prepend the required lines
      content = File.readlines(filename).each {|l| l.chomp!}
      content.unshift(data2lines(data))

      # write the new content in one go
      File.open(filename, "w") do |f|
        f.puts(content)
      end
    end

    def self.unprepend(filename, data)
      # read the old content into an array and remove the required lines
      content = File.readlines(filename).each {|l| l.chomp!}
      data2lines(data).each { |line|
        # we double check that the lines read are still valid since we
        # checked with exists? to prevent possible race conditions (although
        # we could still encounter them since there's no locking)
        if content[0] == line
          content.shift
        end
      }
      # write the new content in one go
      File.open(filename, "w") do |f|
        f.puts(content)
      end
    end

    def self.append(filename, data)
      # write the new content in one go
      File.open(filename, "w+") do |f|
        f.puts(data2lines(data))
      end
    end

    def self.unappend(filename, data)
      content = File.readlines(filename).each {|l| l.chomp!}
      data2lines(data).reverse.each { |line|
        if content[-1] == line
          content.pop
        end
      }
      # write the new content in one go
      File.open(filename, "w") do |f|
        f.puts(content)
      end
    end

  end
end
