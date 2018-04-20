class AddPythonTopic < ActiveRecord::Migration[5.1]
  def up
    Topic.create name: 'python'
  end

  def down
    Topic.where(name: 'python').delete_all
  end
end
