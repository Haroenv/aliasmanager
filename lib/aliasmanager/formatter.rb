class AliasManager
  class Formatter

    def format(command_counts)
      command_counts.map do |command_count|
        "#{command_count[1]} #{command_count[0]}"
      end.join("\n")
    end

  end
end
