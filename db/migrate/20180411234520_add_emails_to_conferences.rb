class AddEmailsToConferences < ActiveRecord::Migration[5.1]
  def change
    add_column :conferences, :emails, :string
  end
end
