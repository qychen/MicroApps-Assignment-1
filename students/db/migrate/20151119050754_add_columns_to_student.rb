class AddColumnsToStudent < ActiveRecord::Migration
  def change
    add_column :students, :last_name, :string
    add_column :students, :first_name, :string
    add_column :students, :courses_taken, :string
    add_column :students, :courses_enrolled, :string
  end
end
