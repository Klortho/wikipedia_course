class DropBlobbbbFromStudents < ActiveRecord::Migration
  def change
    remove_column :students, :blobbbb
  end
end
