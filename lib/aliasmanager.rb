require "open3"

class AliasManager

  def initialize(history_filename)
    @history_filename = history_filename
  end

  def most_used_unaliased_commands

  end

  private


  def commands
    lines.map do |line| Command.from_history_line(line) end
  end

  def lines
    @line ||= File.readlines(File.expand_path(@history_filename))
  end

  Command = Struct.new(:timestamp, :command, :options) do

    def self.from_history_line(line)
      timestamp = line.split(":")[1].strip
      full_command = line.split(";").last.strip.split(" ")
      command = full_command.pop
      options = full_command

      new(timestamp, command, options)
    end

    def aliased?

    end

  end

end
