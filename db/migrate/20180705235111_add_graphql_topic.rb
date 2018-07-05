class AddGraphqlTopic < ActiveRecord::Migration[5.2]
  def up
    Topic.create name: 'graphql'
  end

  def down
    Topic.where(name: 'graphql').delete_all
  end
end
