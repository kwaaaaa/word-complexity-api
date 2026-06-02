module WordComplexity
  class CalculateScore
    def initialize(definitions_count:, synonyms_count:, antonyms_count:)
      @definitions = definitions_count.to_f
      @synonyms = synonyms_count.to_f
      @antonyms = antonyms_count.to_f
    end

    def call
      return 0.0 if @definitions.zero?

      ((@synonyms + @antonyms) / @definitions).round(1)
    end
  end
end
