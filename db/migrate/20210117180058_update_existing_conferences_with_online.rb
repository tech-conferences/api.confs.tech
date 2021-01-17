class UpdateExistingConferencesWithOnline < ActiveRecord::Migration[5.2]
  def change
    Conference.where(city: 'Online').update_all(
      online: true,
      city: nil,
      country: nil
    )
  end
end
