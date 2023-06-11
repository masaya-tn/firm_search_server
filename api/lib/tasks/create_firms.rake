require 'csv'

namespace :create_firms do
  desc "企業初期データ登録"
  task :create_data => :environment do
    CSV.foreach("app/assets/csv/firms.csv") do |row|
      firm = Firm.create(
        code: row[0],
        status: row[1].to_i,
        firm_name: row[2],
        firm_name_kana: row[3],
        post_code: row[4],
        address: row[5],
        representive: row[6],
        representive_kana: row[7],
        phone_number: row[8]
      )
  
      firm.performances.create([
        { 
          sales: row[9].to_i,
          profits: row[10].to_i,
          year: "2022"
        },
        {
          sales: row[11].to_i,
          profits: row[12].to_i,
          year: "2021"
        },
        {
          sales: row[13].to_i,
          profits: row[14].to_i,
          year: "2020"
        }
      ])
    end
  end
end
