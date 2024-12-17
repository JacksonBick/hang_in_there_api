class CreatePosters < ActiveRecord::Migration[7.1]
  def change
    create_table :posters do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :year
      t.boolean :vintage
      t.string :img_url

      t.timestamps
    end
  end
end
