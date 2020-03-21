class AddStartDateAndEndDateToConferences < ActiveRecord::Migration[5.2]
  def up
    add_column :conferences, :start_date, :date
    add_column :conferences, :end_date, :date

    progress_bar = ProgressBar.new(Conference.count)
    Conference.all.in_batches do |conferences|
      conferences.each do |conference|
        progress_bar.increment!
        conference.send :update_start_end_dates
        conference.save(validate: false)
      end
    end
  end

  def down
    remove_column :conferences, :start_date
    remove_column :conferences, :end_date
  end
end
