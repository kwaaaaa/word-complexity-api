require "rails_helper"

RSpec.describe WordComplexity::CalculateScore do
  it "calculates correct score" do
    result = described_class.new(
      definitions_count: 2,
      synonyms_count: 2,
      antonyms_count: 2
    ).call

    expect(result).to eq(2.0)
  end

  it "returns 0 when definitions is 0" do
    result = described_class.new(
      definitions_count: 0,
      synonyms_count: 10,
      antonyms_count: 10
    ).call

    expect(result).to eq(0.0)
  end
end
