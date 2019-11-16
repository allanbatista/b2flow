class CreateJobVersions < ActiveRecord::Migration[6.0]
  def change
    create_table :job_versions, id: :uuid do |t|
      t.references :job, null: false, foreign_key: true, type: :uuid
      t.integer :version, default: 1

      t.timestamps
    end

    add_index :job_versions, [:version, :job_id], unique: true
  end
end
