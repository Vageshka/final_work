class CreateStudents < ActiveRecord::Migration[6.0]
  def change
    create_table :students do |t|
      t.string :fullname
      t.string :departament
      t.string :group
      t.string :wish
      t.text :file
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
