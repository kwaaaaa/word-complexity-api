require "rails_helper"

RSpec.describe "POST /complexity-score", type: :request do
  before do
    stub_request(:get, %r{api.dictionaryapi.dev})
      .to_return(
        status: 200,
        body: [
          {
            "meanings" => [
              { "definitions" => [ { "definition" => "x" } ] }
            ]
          }
        ].to_json,
        headers: { "Content-Type" => "application/json" }
      )
  end

  it "creates request" do
    post "/complexity-score",
         params: [ "happy", "sad" ].to_json,
         headers: { "CONTENT_TYPE" => "application/json" }

    json = JSON.parse(response.body)

    expect(json["job_id"]).to be_present
  end
end
