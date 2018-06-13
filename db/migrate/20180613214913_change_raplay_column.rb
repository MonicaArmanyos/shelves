class ChangeRaplayColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :replays, :replay, :reply
  end
end
