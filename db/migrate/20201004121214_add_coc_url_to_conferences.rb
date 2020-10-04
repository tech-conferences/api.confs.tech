class AddCocUrlToConferences < ActiveRecord::Migration[5.2]
  def change
    add_column :conferences, :cocUrl, :string
    add_column :conferences, :offersSignLanguageOrCC, :boolean, default: false
  end
end
