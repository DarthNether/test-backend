class CreateTareas < ActiveRecord::Migration[6.0]
  def change
    create_table :tareas do |t|
      t.string :titulo
      t.datetime :inicio
      t.datetime :fin
      t.string :email

      t.timestamps
    end
  end
end
