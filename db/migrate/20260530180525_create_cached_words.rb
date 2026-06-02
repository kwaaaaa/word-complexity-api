class CreateCachedWords < ActiveRecord::Migration[8.1]
  def change
    create_table :cached_words do |t|
      t.string :word, null: false
      t.float :score, null: false

      t.timestamps
    end

    add_index :cached_words, :word, unique: true
  end
end
