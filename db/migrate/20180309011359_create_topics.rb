class CreateTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :topics do |t|
      t.string :name
    end

    create_table :conferences_topics, id: false do |t|
      t.integer :topic_id
      t.integer :conference_id
    end

    %w[javascript css php ux ruby ios android data tech-comm general].map do |topic|
      Topic.create name: topic
    end
  end
end
