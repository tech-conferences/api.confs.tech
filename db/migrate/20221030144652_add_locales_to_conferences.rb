class AddLocalesToConferences < ActiveRecord::Migration[6.1]
  def change
    add_column :conferences, :locales, :string
  end
end
