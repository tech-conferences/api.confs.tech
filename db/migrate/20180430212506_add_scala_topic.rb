class AddScalaTopic < ActiveRecord::Migration[5.2]
  def up
    Topic.create name: 'scala'
  end

  def down
    Topic.where(name: 'scala').delete_all
  end
end
