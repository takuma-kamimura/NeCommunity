class CreateCatBreeds < ActiveRecord::Migration[7.0]
  def change
    create_table :cat_breeds do |t|
      t.string :name, index: { unique: true }

      t.timestamps
    end
  end
end
