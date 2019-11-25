class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|

      t.integer :number
      t.datetime :datefrom
      t.datetime :dateto

      t.references :cart, foreign_key: true
 	  t.references :book, foreign_key: true

      t.timestamps
    end
  end
end
