Rails.application.routes.draw do
  post "/complexity-score", to: "complexity_scores#create"
  get "/complexity-score/:job_id", to: "complexity_scores#show"
end
