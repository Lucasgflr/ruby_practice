require_relative 'methods.rb'
require 'mysql2'
require 'dotenv/load'


client = Mysql2::Client.new(host: "db09.blockshopper.com", username: "loki", password: "v4WmZip2K67J6Iq7NXC", database: "applicant_tests")

get_teacher(1, client)
client.close
