class CreateJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :jobs do |t|
      t.references :company, null: false, foreign_key: true
      t.string :title
      t.string :location
      t.string :employment_type
      t.datetime :published_at

      t.timestamps
    end
  end
end
