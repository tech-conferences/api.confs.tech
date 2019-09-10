class AddProductTopic < ActiveRecord::Migration[5.1]
  def up
    Topic.create name: 'product'
  end

  def down
    Topic.where(name: 'product').delete_all
  end
end