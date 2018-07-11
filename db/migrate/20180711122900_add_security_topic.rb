class AddSecurityTopic < ActiveRecord::Migration[5.2]
  def up
    Topic.create name: 'security'
  end

  def down
    Topic.where(name: 'security').delete_all
  end
end
