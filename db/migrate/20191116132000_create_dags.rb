class CreateDags < ActiveRecord::Migration[6.0]
  def change
    create_table :dags, id: :uuid do |t|
      t.string :name, null: false
      t.string :cron
      t.boolean :enable, null: false, default: true
      t.references :team, null: false, foreign_key: true, type: :uuid
      t.references :project, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :dags, [:team_id, :project_id, :name], :unique => true
  end
end
