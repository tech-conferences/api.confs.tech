class AddMastodonToConferences < ActiveRecord::Migration[6.1]
  def change
    add_column :conferences, :mastodon, :string
  end
end
