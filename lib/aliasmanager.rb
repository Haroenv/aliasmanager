require_relative 'aliasmanager/zsh_history'

class AliasManager

  def initialize(cutoff: 0, history_size: 3000)
    @cutoff = cutoff
    @history_size = history_size
  end

  # Reads the output of `alias -L` in stdin

  def most_used_commands_without_aliases
    puts formatted_top_list(without_options(commands_without_aliases))
  end

  def most_used_commands
    puts formatted_top_list(without_options(all_commands))
  end

  def most_used_aliases
    puts formatted_top_list(without_options(commands_using_aliases))
  end

  def total
    puts all_commands.count
  end

  def most_used_consecutive_commands
    command_sequences = []
    all_commands.count.times do |i|
      command_sequences[i] = "#{all_commands[i].split(' ').first} #{(all_commands[i+1]||'').split(" ").first}"
    end

    puts formatted_top_list(command_sequences)
  end

  def most_used_with_subcommands
    commands_with_subcommands = all_commands.select do |command|
      command.split(" ").count >= 2
    end.map do |command|
      command.split(" ")[0..2].join(' ')
    end

    puts formatted_top_list(commands_with_subcommands)
  end

  def most_used_options(diagnosed_command)
    all_options = all_commands.select do |command|
      command.start_with?(diagnosed_command)
    end.map do |command|
      command.split(" ")[0..1].join(' ')
    end

    puts formatted_top_list(all_options)
  end

  private

  def formatted_top_list(commands)
    top_list(commands).select do |command_count|
      command_count[1] >= @cutoff
    end
      .map do |command_count|
        "#{command_count[1]} #{command_count[0]}"
      end.join("\n")
  end

  def top_list(commands)
    commands.group_by { |c| c }
      .each_with_object({}) do |(command, occurences), command_counts|
        command_counts[command] = occurences.count
      end
      .to_a.sort do |a,b| b[1] <=> a[1] end
  end

  def without_options(commands)
    commands.map do |command|
      command.split(" ").first
    end
  end

  def commands_without_aliases
    @commands_without_aliases ||= all_commands - commands_using_aliases
  end

  def commands_using_aliases
    @commands_using_aliases ||= all_commands.clone.keep_if do |command|
      all_aliases.any? do |aliaz|
        command.start_with?(aliaz)
      end
    end
  end

  def all_commands
    @all_commands ||= ZshHistory.new(@history_size).command_history
  end

  def all_aliases
    @all_aliases ||= all_aliases_commands.map do |alias_command|
      alias_command.split(" ")[1].split("=").first
    end
  end

  def all_aliases_commands
    @all_aliases_commands ||= $stdin.readlines
  end

end

