module DictionaryApi
  class Client
    BASE_URL = "https://api.dictionaryapi.dev/api/v2/entries/en".freeze

    def initialize(word)
      @word = word
    end

    def call
      response = connection.get(@word).body
      normalize(response)
    end

    private

    def normalize(response)
      # API case: word not found
      return [] if response.is_a?(Hash) && response["title"] == "No Definitions Found"

      response
    end

    def connection
      @connection ||= Faraday.new(url: BASE_URL) do |f|
        f.response :json

        f.options.open_timeout = 5
        f.options.timeout = 10
      end
    end
  end
end
