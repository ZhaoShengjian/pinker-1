class CreateNlpSearches < ActiveRecord::Migration[5.1]
  def change
    create_table :nlp_searches do |t|
      t.int :id
      t.string :content

      t.timestamps
    end
  end
end
