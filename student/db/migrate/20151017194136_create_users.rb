class CreateUsers < ActiveRecord::Migration
  def up
  	#used {:id => false} so that the id field is not automatically generated
    create_table :users, do |t|
      t.column "unique_id", :integer
      t.column "first_name", :string, :limit => 100
      t.column "last_name", :string
      t.column "courses_enrolled", :integer
      t.column "courses_taken", :integer
      #t.datetime "created_at"
      #t.datetime "updated_at"
      t.timestamps null: false
    end
    #add_index("users", "permalink")
  end

  def down
  	drop_table :users
  end
end
