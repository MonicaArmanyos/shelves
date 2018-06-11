class AddBidDurationStateToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :bid_duration_state, :boolean, default: 0
  end
end
