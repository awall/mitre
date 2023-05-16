class CreateEntities < ActiveRecord::Migration[6.1]
  def change
    create_table :entities do |t|
      t.references :sentence

      t.string :text

      # Use `typ` instead of `type`, as `type` is a reserved word in
      # ActiveRecord. See 
      # https://apidock.com/rails/ActiveRecord/ModelSchema/ClassMethod/inheritance_column.
      t.string :typ

      t.timestamps
    end
  end
end
