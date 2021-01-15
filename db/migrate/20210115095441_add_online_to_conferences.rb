class AddOnlineToConferences < ActiveRecord::Migration[5.2]
  def change
    add_column :conferences, :online, :boolean, default: false
  end
end
