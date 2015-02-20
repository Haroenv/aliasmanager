class AliasManager
  class ZshHistory

    def initialize(history_size = 3000)
      @history_size = history_size
    end

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
      @history ||= `tail -n#{@history_size} ~/.zsh_history`.split("\n")
    end

  end
end
