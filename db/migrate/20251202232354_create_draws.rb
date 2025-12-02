class CreateDraws < ActiveRecord::Migration[7.0]
  def change
    create_table :draws do |t|
      t.string :user_name
      t.string :drawn_name

      t.timestamps
    end
  end
end
