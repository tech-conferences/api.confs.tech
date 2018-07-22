class AddTweetAtToConferences < ActiveRecord::Migration[5.2]
  def change
    add_column :conferences, :tweeted_at, :datetime
  end
end
