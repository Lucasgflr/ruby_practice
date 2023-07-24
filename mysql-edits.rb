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
