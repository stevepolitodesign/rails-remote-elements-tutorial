class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :title, null: false
      t.references :task, null: false, foreign_key: true
      t.boolean :complete, null: false, default: false

      t.timestamps
    end
  end
end
