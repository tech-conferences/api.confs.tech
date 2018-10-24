class AddAffiliateAttrToConferences < ActiveRecord::Migration[5.2]
  def change
    add_column :conferences, :affiliate_url, :string
    add_column :conferences, :affiliate_text, :string
  end
end
