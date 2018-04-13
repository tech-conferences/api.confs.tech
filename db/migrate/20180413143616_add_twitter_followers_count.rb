class AddTwitterFollowersCount < ActiveRecord::Migration[5.1]
  def change
    add_column :conferences, :twitter_followers, :integer
  end
end
