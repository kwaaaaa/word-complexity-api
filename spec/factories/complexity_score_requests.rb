FactoryBot.define do
  factory :complexity_score_request do
    status { "pending" }
    words { [ "happy", "sad" ] }
    result { {} }
  end
end
