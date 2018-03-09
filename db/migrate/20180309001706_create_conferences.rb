class CreateConferences < ActiveRecord::Migration[5.1]
  def up
    create_table :conferences do |t|
      t.string :uuid, unique: true
      t.string :name
      t.string :url
      t.string :city
      t.string :country
      t.string :startDate
      t.string :endDate
      t.string :cfpStartDate
      t.string :cfpEndDate
      t.string :cfpUrl
      t.string :twitter

      t.timestamps
    end
    add_index :conferences, :uuid, unique: true
  end

  def down
    drop_table :conferences
  end
end
