class AddDevopsTopic < ActiveRecord::Migration[5.1]
  def up
    Topic.create name: 'devops'
  end

  def down
    Topic.where(name: 'devops').delete_all
  end
end
