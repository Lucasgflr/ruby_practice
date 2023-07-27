def get_teacher(id, client)
  f = "select firstname, middlename, lastname, birthdate from teachers_lucasribeiro where ID = #{id}"
  results = client.query(f).to_a
  if results.count.zero?
    puts "Teacher with ID #{id} was not found."
  else
    puts "Teacher #{results[0]['firstname']} #{results[0]['middlename']} #{results[0]['lastname']} was born on #{(results[0]['birthdate']).strftime("%d %b %Y (%A)")}"
  end
end
def get_teacher(id, client)
  f = "SELECT first_name, middle_name, last_name, birth_date FROM teachers_lucasribeiro WHERE id = #{id}"
  results = client.query(f).to_a
  if results.count.zero?
    p "ID #{id} wasn't found."
  else
    p "Teacher #{results[0]['first_name']} #{results[0]['middle_name']} #{results[0]['last_name']} was born on #{(results[0]['birth_date']).strftime("%d %b %Y (%A)")}"
  end
end

# 1

def get_subject_teachers(subject_id, client)
  q = "SELECT s.name, t.first_name, t.middle_name, t.last_name FROM subjects_lucasribeiro AS s
  JOIN teachers_lucasribeiro AS t
  ON s.id = t.subject_id WHERE s.id = #{subject_id}"
  results = client.query(q).to_a

  if results.count.zero?
    p "Nobody teaches the subject with ID #{subject_id}."
  else
    string = ""
    results.each do |row|
    string += "Subject: #{row['name']}\nTeachers:\n#{row['first_name']} #{row['middle_name']} #{row['last_name']}\n"
    end
    p string
  end
end

# 2

def get_class_subjects(subject_name, client)
  q = "SELECT c.name AS class_name, s.name AS subject_name, t.first_name, t.middle_name, t.last_name FROM classes_lucasribeiro AS c
  JOIN teachers_classes_lucasribeiro AS tc
    ON tc.class_id = c.id
  JOIN teachers_lucasribeiro AS t
    ON t.id = tc.teacher_id
  JOIN subjects_lucasribeiro AS s
    ON s.id = t.subject_id WHERE s.name = \"#{subject_name}\""

    results = client.query(q).to_a

    if results.count.zero?
      p "There aren't teachers teaching #{subject_name}."
    else
      string = "Subject: #{results[0]['subject_name']}\n"
      results.each do |row|
      string += "Classes: #{row['class_name']} (#{row['first_name']} #{row['middle_name']} #{row['last_name']})\n"
      end
      p string
    end
end

# 3

def get_teachers_list_by_letter(letter, client)
  q = "SELECT first_name, middle_name, last_name, s.name AS subject_name FROM classes_llucasribeiro AS c
  JOIN teachers_classes_lucasribeiro AS tc
    ON tc.class_id = c.id
  JOIN teachers_lucasribeiro AS t
    ON t.id = tc.teacher_id
  JOIN subjects_lucasribeiro AS s
    ON s.id = t.subject_id
  WHERE first_name LIKE '%#{letter}%' OR last_name LIKE '%#{letter}%'"
  results = client.query(q).to_a

  if results.count.zero?
    p "There aren't teachers whose first or last name contains the letter \"#{letter}\""
  else
    string = ""
    results.each do |row|
    string += "#{row['first_name'][0] + '.'} #{row['middle_name'][0] + '.'} #{row['last_name']} (#{row['subject_name']})\n"
    end
    p string
  end
end

def set_md5(client)
  t = "SELECT * FROM teachers_lucasribeiro"
  teachers = client.query(t).to_a

  teachers.each do |teacher|
    hash_t = Digest::MD5.hexdigest "#{teacher[:first_name]}#{teacher[:middle_name]}#{teacher[:last_name]}#{teacher[:birth_date]}#{teacher[:subject_id]}#{teacher[:current_age]}"
    update_qry = "UPDATE teachers_lucasribeiro SET md5 = \"#{hash_t}\" WHERE id = #{teacher['id']};"
    client.query(update_qry)
  end
end



def get_class_info(class_id, client)
  involved_teachers = "SELECT c.name, t.first_name, t.last_name
   FROM teachers_classes_lucasribeiro AS tc
     JOIN classes_lucasribeiro AS c
     ON tc.class_id = c.id
     JOIN teachers_lucasribeiro AS t
     ON tc.teacher_id = t.id
     WHERE c.id = #{class_id};"

  responsible_teacher = "SELECT c.name, t.first_name, t.last_name
   FROM classes_lucasribeiro AS c
     JOIN teachers_lucasribeiro AS t
       ON c.responsible_teacher_id = t.id
   WHERE c.id = #{class_id};"

  results_involved = client.query(involved_teachers).to_a
  results_responsible = client.query(responsible_teacher).to_a

  if results_involved.empty? || results_responsible.empty?
    puts "There are no involved or responsible teachers in class with id #{class_id}"
  else
    string = "Class name: #{results_responsible[0]['name']}\nResponsible teacher: #{results_responsible[0]['first_name']} #{results_responsible[0]['last_name']}\nInvolved teachers:\n"

    results_involved.each do |row|
      string += "#{row['first_name']} #{row['last_name']}\n"
    end

    puts string.strip
  end
end

def get_teachers_by_year(year, client)
  year_t = "SELECT t.first_name, t.last_name FROM teachers_lucasribeiro t WHERE YEAR(birth_date) = \"#{year}\";"
  results = client.query(year_t).to_a

  if results.empty?
    p "There are no teachers born in #{year}"
  else
    string = ""

    results.each do |row|
      string += "Teachers born in #{year}: #{row['first_name']} #{row['last_name']}"

    end
    p string
  end
end

