class AliasManager
  class Aliases

    def all_aliases
      @all_aliases ||= all_aliases_commands.map do |alias_command|
        alias_command.split(" ")[1].split("=").first
      end
    end

    # Reads the output of `alias -L` in stdin
    def all_aliases_commands
      @all_aliases_commands ||= $stdin.readlines
    end

  end
end
