require_relative 'aliasmanager/zsh_history'
require_relative 'aliasmanager/formatter'

class AliasManager

  def initialize(cutoff: 0, history_size: 3000)
    @cutoff = cutoff
    @history_size = history_size
  end

  def most_used_commands
    formatted_top_list(without_options(all_commands))
  end

  def most_used_options(diagnosed_command)
    all_options = all_commands.select do |command|
      command.start_with?(diagnosed_command)
    end.map do |command|
      command.split(" ")[0..1].join(' ')
    end

    formatted_top_list(all_options)
  end

  private

  def formatted_top_list(commands)
    Formatter.new.format(top_list(commands))
  end

  def top_list(commands)
    Sorter.new(@cutoff).top_count(commands)
  end

  def without_options(commands)
    commands.map do |command|
      command.split(" ").first
    end
  end

  def all_commands
    @all_commands ||= ZshHistory.new(@history_size).command_history
  end

end

