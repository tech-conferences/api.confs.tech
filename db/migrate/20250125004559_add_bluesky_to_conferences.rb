class AddBlueskyToConferences < ActiveRecord::Migration[6.1]
  def change
    add_column :conferences, :bluesky, :string
  end
end
