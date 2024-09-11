# frozen_string_literal: true

class CreateAssertions < ActiveRecord::Migration[7.0]
  def change
    create_table :assertions do |t|
      t.string :url
      t.string :text
      t.string :status
      t.string :snapshotUrl
      t.integer :numLinks
      t.integer :numImages

      t.timestamps
    end
  end
end
