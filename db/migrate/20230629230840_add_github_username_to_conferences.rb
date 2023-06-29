class AddGithubUsernameToConferences < ActiveRecord::Migration[6.1]
  def change
    add_column :conferences, :github, :string
  end
end
