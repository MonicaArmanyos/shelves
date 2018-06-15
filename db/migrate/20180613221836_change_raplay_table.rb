class ChangeRaplayTable < ActiveRecord::Migration[5.1]
  def change
    rename_table :replays, :replies
  end
end
