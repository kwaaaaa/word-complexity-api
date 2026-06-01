require "rails_helper"

RSpec.describe WordComplexity::ExtractFeatures do
  let(:word) { "happy" }

  let(:api_response) do
    [
      {
        "word" => "happy",
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
    ]
  end

  before do
    stub_request(:get, "https://api.dictionaryapi.dev/api/v2/entries/en/#{word}")
      .to_return(
        status: 200,
        body: api_response.to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end

  it "extracts features correctly" do
    result = described_class.new(word).call

    expect(result).to eq({
                           definitions: 2,
                           synonyms: 2,
                           antonyms: 1
                         })
  end
end
