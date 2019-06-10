class CreateMoments < ActiveRecord::Migration[5.2]
  def change
    create_table :moments do |t|
      t.string :name
      t.string :description
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
