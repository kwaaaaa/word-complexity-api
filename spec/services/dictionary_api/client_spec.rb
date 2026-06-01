require "rails_helper"

RSpec.describe DictionaryApi::Client do
  describe "#call" do
    let(:word) { "happy" }

    before do
      stub_request(:get, "https://api.dictionaryapi.dev/api/v2/entries/en/happy")
        .to_return(
          status: 200,
          body: [
            {
              "word" => "happy",
              "meanings" => [
                {
                  "definitions" => [
                    { "definition" => "feeling joy" }
                  ]
                }
              ]
            }
          ].to_json,
          headers: { "Content-Type" => "application/json" }
        )
    end

    it "returns parsed JSON array" do
      result = described_class.new(word).call

      expect(result).to be_an(Array)
      expect(result.first["word"]).to eq("happy")
    end
  end
end
