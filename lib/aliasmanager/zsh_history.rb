class AliasManager
  class ZshHistory

    def command_history
      @command_history ||= history.select do |command|
        command.start_with?(':')
      end.map do |line|
        line.split(";").last.gsub("\n", "")
      end
    end

    private

    # lines of zsh_history have the format `: 1424438183:0;which zsh`
    def history
      @history ||= File.readlines File.expand_path "~/.zsh_history"
    end

  end
end
