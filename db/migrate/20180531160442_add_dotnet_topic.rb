class AddDotnetTopic < ActiveRecord::Migration[5.2]
  def up
    Topic.create name: 'dotnet'
  end

  def down
    Topic.where(name: 'dotnet').delete_all
  end
end
