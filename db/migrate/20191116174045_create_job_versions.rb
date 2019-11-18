class CreateJobVersions < ActiveRecord::Migration[6.0]
  def change
    create_table :job_versions, id: :uuid do |t|
      t.references :job, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
