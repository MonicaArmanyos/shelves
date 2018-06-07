class AddBidDurationToBooks < ActiveRecord::Migration[5.1]
  def change
    add_column :books, :bid_duration, :datetime
  end
end
