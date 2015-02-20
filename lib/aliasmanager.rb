class AliasManager

  # Reads the output of `alias -L` in stdin
  def self.most_used_commands_without_aliases
    new.most_used_commands_without_aliases
  end

  def most_used_commands_without_aliases
    put_top_list(commands_without_aliases)
  end

  def self.most_used_commands
    new.most_used_commands
  end

  def most_used_commands
    put_top_list(full_commands)
  end

  def self.most_used_aliases
    new.most_used_aliases
  end

  def most_used_aliases
    put_top_list(commands_using_aliases)
  end

  private

  def commands_without_aliases
    @commands_without_aliases ||= full_commands - commands_using_aliases
  end

  def commands_using_aliases
    @commands_using_aliases ||= full_commands.clone.keep_if do |command|
      all_aliases.any? do |aliaz|
        command.start_with?(aliaz)
      end
    end
  end

  def full_commands
    @full_commands ||= history.select do |command|
      command.start_with?(':')
    end.map do |line|
      line.split(";").last.gsub("\n", "")
    end
  end

  # lines of zsh_history have the format `: 1424438183:0;which zsh`
  def history
    @history ||= File.readlines File.expand_path "~/.zsh_history"
  end

  def all_aliases
    @all_aliases ||= all_aliases_commands.map do |alias_command|
      alias_command.split(" ")[1].split("=").first
    end
  end

  def all_aliases_commands
    @all_aliases_commands ||= $stdin.readlines
  end

  def top_list(commands)
    commands.group_by { |c| c.split(' ').first }
      .each_with_object({}) do |(command, occurences), command_counts|
        command_counts[command] = occurences.count
      end
      .to_a.sort do |a,b| b[1] <=> a[1] end
  end

  def put_top_list(commands)
    top_list(commands).each do |command_count|
      puts "#{command_count[1]} #{command_count[0]}"
    end
  end

end

