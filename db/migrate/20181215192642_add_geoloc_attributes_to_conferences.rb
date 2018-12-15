class AddGeolocAttributesToConferences < ActiveRecord::Migration[5.2]
  def change
    add_column :conferences, :latitude, :float
    add_column :conferences, :longitude, :float
  end
end
