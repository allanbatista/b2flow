class CreateJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :jobs, id: :uuid do |t|
      t.string :name, null: false
      t.references :team, null: false, foreign_key: true, type: :uuid
      t.references :project, null: false, foreign_key: true, type: :uuid
      t.string :engine, null: false
      t.string :cron
      t.timestamp :start_at
      t.timestamp :end_at
      t.boolean :enable, null: false, default: true

      t.timestamps
    end

    add_index :jobs, [:name, :project_id], unique: true
  end
end
