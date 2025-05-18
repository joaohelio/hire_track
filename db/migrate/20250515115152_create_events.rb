class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.references :eventable, polymorphic: true, null: false
      t.jsonb :data, default: {}
      t.string :status

      t.datetime :created_at
    end
  end
end
