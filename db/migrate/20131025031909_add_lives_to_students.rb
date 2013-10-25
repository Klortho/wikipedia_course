class AddLivesToStudents < ActiveRecord::Migration
  def change
    add_column :students, :lives, :string
  end
end
