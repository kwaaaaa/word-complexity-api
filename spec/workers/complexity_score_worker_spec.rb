require "rails_helper"

RSpec.describe ComplexityScoreWorker do
  describe "#perform" do
    let!(:request) do
      create(:complexity_score_request, words: [ "happy", "sad" ])
    end

    before do
      stub_request(:get, %r{api.dictionaryapi.dev})
        .to_return(
          status: 200,
          body: [
            {
              "meanings" => [
                {
                  "definitions" => [
                    { "definition" => "x" },
                    { "definition" => "y" }
                  ],
                  "synonyms" => [ "a", "b" ],
                  "antonyms" => [ "c" ]
                }
              ]
            }
          ].to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "updates request and completes it" do
      described_class.new.perform(request.uuid)

      request.reload

      expect(request.status).to eq("completed")

      expect(request.result).to eq({
                                     "happy" => 1.5,
                                     "sad" => 1.5
                                   })
    end
  end
end
