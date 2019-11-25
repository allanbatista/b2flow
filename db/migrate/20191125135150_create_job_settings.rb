class CreateJobSettings < ActiveRecord::Migration[6.0]
  def change
    create_table :job_settings, id: :uuid do |t|
      t.references :job, null: false, foreign_key: true, type: :uuid
      t.jsonb :settings, default: {}

      t.timestamps
    end

    add_index :job_settings, :job_id, name: "settings_job_index"
  end
end
