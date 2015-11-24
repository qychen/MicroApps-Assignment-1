class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students, id: false do |t|
      t.string :uni, null: false
      t.timestamps null: false
    end
    execute "ALTER TABLE students ADD PRIMARY KEY (uni);"
  end
end
