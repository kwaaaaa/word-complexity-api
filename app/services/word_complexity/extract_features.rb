module WordComplexity
  class ExtractFeatures
    def initialize(word)
      @word = word
    end

    def call
      data = DictionaryApi::Client.new(@word).call
      meanings = data.first&.fetch("meanings", []) || []

      {
        definitions: meanings.sum { |m| (m["definitions"] || []).size },
        synonyms: meanings.sum { |m| (m["synonyms"] || []).size },
        antonyms: meanings.sum { |m| (m["antonyms"] || []).size }
      }
    end
  end
end
