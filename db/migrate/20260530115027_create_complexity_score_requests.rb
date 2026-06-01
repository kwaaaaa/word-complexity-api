class CreateComplexityScoreRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :complexity_score_requests do |t|
      t.uuid :uuid, null: false
      t.jsonb :words, null: false, default: []
      t.jsonb :result, null: false, default: {}
      t.string :status, null: false, default: "pending"
      t.text :error_message

      t.timestamps
    end

    add_index :complexity_score_requests, :uuid, unique: true
  end
end
