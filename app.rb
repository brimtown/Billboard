#!/usr/bin/env ruby

require 'active_record'
require 'csv'

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

def import_csv(table, year)
  table.each do |row|
    single = ChartSingle.new
    single.title = row[2]
    single.artist = row[1]
    single.position = row[0]
    single.year = year

    single.save
  end
end

def import_all_data
  Dir.chdir("billboard")
  Dir.glob("*.csv") do |file|
    #Non-ASCII character in some of the files necessitated the encoding parameter
    table = CSV.read(file, encoding: "iso-8859-1:UTF-8")[1 .. -1]
    #Trim the .csv from the filename to get the year
    year = file[0..-5]
    import_csv table, year
  end
end

establish_db_connection
migrate_db
import_all_data
