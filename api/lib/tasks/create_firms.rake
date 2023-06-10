require 'csv'

namespace :create_firms do
  desc "企業初期データ登録"
  task :create_firms => :environment do
    firms = []
    CSV.foreach("app/assets/csv/firms.csv") do |row|
      firm = {}
      firm["code"] = row[0]
      firm["status"] = row[1].to_i
      firm["firm_name"] = row[2]
      firm["firm_name_kana"] = row[3]
      firm["post_code"] = row[4]
      firm["address"] = row[5]
      firm["representive"] = row[6]
      firm["representive_kana"] = row[7]
      firm["phone_number"] = row[8]
      firms.push(firm)
    end
    Firm.create(firms)
  end
end
