require "rails_helper"

RSpec.describe "GET /complexity-score/:id", type: :request do
  it "returns pending" do
    request_record = create(:complexity_score_request, status: "pending")

    get "/complexity-score/#{request_record.uuid}"

    json = JSON.parse(response.body)

    expect(json).to eq({ "status" => "pending" })
  end
end
