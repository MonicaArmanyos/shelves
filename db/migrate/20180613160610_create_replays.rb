class CreateReplays < ActiveRecord::Migration[5.1]
  def change
    create_table :replays do |t|
      t.text :replay
      t.references :user, foreign_key: true, index: true
      t.references :comment, foreign_key: true, index: true     
      t.timestamps
    end
  end
end
