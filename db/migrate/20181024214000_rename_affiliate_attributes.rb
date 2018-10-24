class RenameAffiliateAttributes < ActiveRecord::Migration[5.2]
  def change
    rename_column :conferences, :affiliate_url, :affiliateUrl
    rename_column :conferences, :affiliate_text, :affiliateText
  end
end
