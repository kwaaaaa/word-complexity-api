module WordComplexity
  class Pipeline
    CACHE_TTL = 30.days

    def initialize(request)
      @request = request
    end

    def call
      @request.update!(status: :in_progress)

      result = @request.words.to_h do |word|
        [ word, score_for(word) ]
      end

      @request.update!(
        result: result,
        status: :completed
      )

      result

    rescue StandardError => e
      @request.update!(
        status: :failed,
        error_message: "#{e.class}: #{e.message}"
      )

      Rails.logger.error(
        "[WordComplexity::Pipeline] failed request_uuid=#{@request.uuid} error=#{e.class}: #{e.message}"
      )

      raise
    end

    private

    def score_for(word)
      cached = CachedWord.find_by(word: word)

      return cached.score if cache_valid?(cached)

      features = ExtractFeatures.new(word).call

      score = CalculateScore.new(
        definitions_count: features[:definitions],
        synonyms_count: features[:synonyms],
        antonyms_count: features[:antonyms]
      ).call

      upsert_cache(word, score)

      score
    end

    def cache_valid?(cached)
      cached.present? && cached.updated_at > CACHE_TTL.ago
    end

    def upsert_cache(word, score)
      cached = CachedWord.find_or_initialize_by(word: word)

      cached.update!(score: score)
    end
  end
end
