class CreateJobExecutions < ActiveRecord::Migration[6.0]
  def change
    create_table :job_executions, id: :uuid do |t|
      t.string :status, null: false, default: 'enqueued'
      t.datetime :enqueued_at
      t.datetime :started_at
      t.datetime :finished_at

      t.references :job, null: false, foreign_key: true, type: :uuid
      t.references :job_version, null: false, foreign_key: true, type: :uuid
      t.references :job_setting, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :job_executions, :job_id, name: "executions_job_index"
  end
end
