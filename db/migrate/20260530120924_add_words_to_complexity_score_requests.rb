class AddWordsToComplexityScoreRequests < ActiveRecord::Migration[8.1]
  def change
    add_column :complexity_score_requests,
               :words,
               :jsonb,
               null: false,
               default: []
  end
end
