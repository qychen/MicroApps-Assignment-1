class AddColumnstoCourse < ActiveRecord::Migration
  def change
    add_column :courses, :current, :boolean
  end
end
