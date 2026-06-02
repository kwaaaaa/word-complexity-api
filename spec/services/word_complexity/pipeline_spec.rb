require "rails_helper"

RSpec.describe WordComplexity::Pipeline do
  let(:request) do
    create(:complexity_score_request, words: [ "happy" ])
  end

  before do
    stub_request(:get, /api.dictionaryapi.dev/)
      .to_return(
        body: [
          {
            "meanings" => [
              {
                "definitions" => [ {}, {} ],
                "synonyms" => [ "a", "b" ],
                "antonyms" => [ "c" ]
              }
            ]
          }
        ].to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end

  it "computes score and updates request" do
    result = described_class.new(request).call

    request.reload

    expect(request.status).to eq("completed")
    expect(request.result).to eq(result)

    # (2 synonyms + 1 antonym) / 2 definitions
    expect(result["happy"]).to eq(1.5)
  end

  it "uses cached score when present" do
    CachedWord.create!(
      word: "happy",
      score: 42.0
    )

    result = described_class.new(request).call

    expect(result["happy"]).to eq(42.0)
  end
end
