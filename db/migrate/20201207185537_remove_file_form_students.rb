class RemoveFileFormStudents < ActiveRecord::Migration[6.0]
  def change
    remove_column :students, :file, :text
  end
end
