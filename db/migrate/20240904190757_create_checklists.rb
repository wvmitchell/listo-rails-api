class CreateChecklists < ActiveRecord::Migration[7.2]
  def change
    create_table :checklists do |t|
      t.string :title
      t.boolean :locked

      t.timestamps
    end
  end
end
