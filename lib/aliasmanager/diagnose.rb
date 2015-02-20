require_relative 'sorter'
class AliasManager
  class Diagnose

    def initialize(cutoff: 0, history_size: 3000)
      @history_size = history_size
      @recommended_aliases = []
    end

    def execute
      manager = AliasManager.new(cutoff: 20, history_size: 3000)

      puts "Your most used commands are"

      diagnosed_commands_with_counts.each do |command_with_count|
        puts command_with_count[0]
      end

      puts "Let's take a look at how you can save time and typing for each of these."

      diagnosed_commands_with_counts.each do |command_with_count|
        diagnose_command(command_with_count[0], command_with_count[1])
      end

      puts "Here are the aliases we recommend you add to your dotfiles:"
      @recommended_aliases.each do |aliaz|
        puts aliaz
      end

    end

    private

    def diagnosed_commands_with_counts
      Sorter.new.top_count(all_commands)[0..9]
    end

    def all_commands
      @all_commands ||= ZshHistory.new(@history_size).command_history.map do |full_command|
        full_command.split(' ').first
      end
    end

    def diagnose_command(command, times_used)
      return unless improvable?(command)
      puts "In the last #{@history_size} commands, you've used `#{command}` #{times_used} times."
      if shortenable?(command)
        puts "This command could be aliased to something shorter."
        puts "What do you think would be a good alias for `#{command}`? (type Enter to skip)"
        aliaz = STDIN.gets.chomp
        @recommended_aliases << "alias #{aliaz}='#{command}'"
      end
    end

    def improvable?(command)
      shortenable?(command)
    end

    def shortenable?(command)
      command.size > 2
    end


  end
end
