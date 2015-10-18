class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
	t.string "room"
	t.string "title"
	t.string "students", :default =>"",:null=>true

      t.timestamps 
    end
  end
end
