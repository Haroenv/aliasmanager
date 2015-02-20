class AliasManager
  class Sorter

    def initialize(cutoff = 0)
      @cutoff = cutoff
    end

    def top_count(strings)
      strings.group_by { |strings| strings }
        .map do |string, occurences|
          [string, occurences.count]
        end
        .sort { |a,b| b[1] <=> a[1] }
        .select { |count| count[1] >= @cutoff }
    end

  end
end
