class AddTsvToEvents < ActiveRecord::Migration
  def change
    add_column :events, :tsv, :tsvector
  end
end
