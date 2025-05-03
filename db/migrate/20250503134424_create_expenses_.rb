class CreateExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.string :title
      t.float :value
      t.datetime :spent_on
    end
  end
end
