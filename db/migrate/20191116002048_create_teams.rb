class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams, id: :uuid do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :teams, :name, unique: true
  end
end
