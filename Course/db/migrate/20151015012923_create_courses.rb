class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
	t.string "Room"
	t.string "Title"
	t.integer "Students", :default =>"",:null=>true

      t.timestamps 
    end
  end
end
