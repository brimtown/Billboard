require 'active_record'
require 'csv'

PATH_TO_DATA = './billboard/'
PATH_TO_TEST = './billboard/1950.csv'

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

def import_csv(table)
  table.each do |row|
    single = ChartSingle.new
    single.title = row[2]
    single.artist = row[1]
    single.position = row[0]
    single.year = 1950

    single.save
  end
end

def import_data
  table = CSV.read(PATH_TO_TEST)[1 .. -1]
  #puts "table"
  #puts table
  import_csv table
end

establish_db_connection
#migrate_db
import_data