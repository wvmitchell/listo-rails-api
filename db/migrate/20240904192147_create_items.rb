class CreateItems < ActiveRecord::Migration[7.2]
  def change
    create_table :items do |t|
      t.text :content
      t.boolean :checked
      t.integer :ordering
      t.references :checklist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
