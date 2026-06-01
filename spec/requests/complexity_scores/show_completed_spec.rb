require "rails_helper"

RSpec.describe "GET /complexity-score/:id", type: :request do
  it "returns result" do
    request_record = create(:complexity_score_request,
                            status: "completed",
                            result: { "happy" => 3.0 })

    get "/complexity-score/#{request_record.uuid}"

    json = JSON.parse(response.body)

    expect(json).to eq({
                         "status" => "completed",
                         "result" => { "happy" => 3.0 }
                       })
  end
end
