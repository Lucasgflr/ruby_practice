require 'mysql2'

client = Mysql2::Client.new(
  host: 'localhost',
  username: 'root',
  password: '',
  database: 'database1'
)

#1
results = client.query("SELECT * FROM people_csv")

#2
p "First 10 records:"
results.each_with_index do |row, index|
  break if index >= 10
  
  puts "ID: #{row['id']}, Firstname: #{row['firstname']}, Lastname: #{row['lastname']}, Email: #{row['email']}"
end

#3
doctor_count = client.query("SELECT COUNT(*) AS count FROM people_<your_name> WHERE profession = 'doctor'").first['count']
p "Number of doctors: #{doctor_count}"

#4
client.query("UPDATE people_<your_name> SET email2 = REPLACE(email2, '@gmail.com', '@hotmail.com') WHERE profession = 'Ecologist'")
p "Emails updated successfully!"

client.close
