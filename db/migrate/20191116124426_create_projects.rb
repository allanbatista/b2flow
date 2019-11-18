class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects, id: :uuid do |t|
      t.string :name, null: false
      t.references :team, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
    
    add_index :projects, [:name, :team_id], unique: true
  end
end
