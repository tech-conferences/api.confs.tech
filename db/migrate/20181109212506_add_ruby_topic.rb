class AddRubyTopic < ActiveRecord::Migration[5.2]
  def up
    Topic.create name: 'ruby'
  end

  def down
    Topic.where(name: 'ruby').delete_all
  end
end
