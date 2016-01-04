require 'active_record'

def establish_db_connection
  ActiveRecord::Base.establish_connection(
    :adapter => 'postgresql',
    :user => 'timbrown',
    :database => 'timbrown'
  )
end

class ChartSingle < ActiveRecord::Base

end

class CreateChartSinglesTable < ActiveRecord::Migration
  def up
    create_table :chart_singles do |t|
      t.text :title
      t.text :artist
      t.integer :year
      t.integer :position
    end
  end 

  def down
    drop_table :chart_singles
  end
end

def migrate_db
  CreateChartSinglesTable.migrate(:up)
end

establish_db_connection
migrate_db