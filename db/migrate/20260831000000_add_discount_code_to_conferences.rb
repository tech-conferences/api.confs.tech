class AddDiscountCodeToConferences < ActiveRecord::Migration[6.1]
  def change
    add_column :conferences, :discountCode, :string
  end
end
