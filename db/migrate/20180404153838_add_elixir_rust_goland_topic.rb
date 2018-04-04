class AddElixirRustGolandTopic < ActiveRecord::Migration[5.1]
  def up
    Topic.create name: 'golang'
    Topic.create name: 'elixir'
    Topic.create name: 'rust'
  end

  def down
    Topic.where(name: 'golang').delete_all
    Topic.where(name: 'elixir').delete_all
    Topic.where(name: 'rust').delete_all
  end
end
