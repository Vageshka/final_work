class CreateOffers < ActiveRecord::Migration[6.0]
  def change
    create_table :offers do |t|
      t.references :student, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.boolean :comp_agree, default: false
      t.boolean :stud_agree, default: false

      t.timestamps
    end
  end
end
