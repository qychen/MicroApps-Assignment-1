class AlterCourses < ActiveRecord::Migration
  def change
	rename_table("courses","classes")
	add_column("classes","name",:string)
	change_column("classes"
  end
end
