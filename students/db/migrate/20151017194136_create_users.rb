class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.column "unique_id", :integer
      t.column "first_name", :string
      t.column "last_name", :string
      t.column "courses_enrolled", :string
      t.column "courses_taken", :string
    end
  end

  def down
  	drop_table :users
  end
end
