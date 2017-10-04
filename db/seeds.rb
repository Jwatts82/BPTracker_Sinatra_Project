people_list = [
  ['Louis', 'Steinn', '1953-12-07', 63],
  ['Kem', 'Sri', '1961-02-18', 56]
]

people_list.each do |person|
  Person.create(first_name: person[0], last_name: person[1],
                dob: person[2], age: person[3])
end

users_list = [
  ['LSteinn72','pword', 1],
  ['KSri08', 'pword', 2]
]

users_list.each do |user|
  User.create(username: user[0], password: user[1], person_id: user[2])
end

readings_list = [
  [115,	75,	80,	'2017-09-18 07:00',	'N', 1],
  [125,	85,	82,	'2017-09-18 12:00',	'P-HBP', 1],
  [139,	89,	85,	'2017-09-18 15:33',	'P-HBP', 1],
  [145,	92,	88,	'2017-09-18 18:30',	'HBP-1', 1],
  [115,	78,	82,	'2017-09-18 21:30',	'N', 1],
  [115,	75,	79,	'2017-09-01 06:30',	'N', 1],
  [130,	85,	82,	'2017-09-01 16:30',	'P-HBP', 1],
  [125,	82,	82,	'2017-09-04 12:30',	'P-HBP', 1],
  [141,	90,	83,	'2017-09-04 19:45',	'HBP-1', 1],
  [135,	87,	83,	'2017-09-09 08:30',	'P-HBP', 1],
  [130,	85,	82,	'2017-09-09 06:30',	'P-HBP', 1],
  [145,	92,	85,	'2017-09-12 11:00',	'HBP-1', 1],
  [128,	84,	83,	'2017-09-12 15:00',	'P-HBP', 1],
  [119,	79,	82,	'2017-09-12 20:00',	'N', 1],
  [125,	82,	83,	'2017-09-17 10:30',	'P-HBP',	2],
  [120,	80,	80,	'2017-09-17 15:30',	'P-HBP',	2],
  [118,	77,	82,	'2017-09-17 07:30',	'N',	2]
]

readings_list.each do |reading|
  Reading.create(systolic: reading[0],
                 diastolic: reading[1],
                 pulse: reading[2],
                 reading_date_time: reading[3],
                 category: reading[4],
                 person_id: reading[5])
end

comment_list = [
  'wake-up check-in',
  'just ate lunch...stressful morning',
  'not feeling well',
  'in a rush...in traffic',
  'relaxing',
  'morning check-in',
  'work was a doozy...',
  'missed morning check-in, running late',
  "bad day...don't feel well",
  'late check-in',
  'driving, in a rush, forgot afternoon check-in',
  'upset...',
  'feeling better, doing an extra check-in',
  'bedtime, thank goodness',
  'at work being annoyed...',
  'feeling good'
]

comment_list.each do |comment|
  Comment.create(content: comment)
end

comment_readings_list = [
  [1, 1],
  [2, 2],
  [3, 3],
  [4, 4],
  [5, 5],
  [6, 6],
  [7, 7],
  [8, 8],
  [9, 9],
  [10, 10],
  [11, 11],
  [12, 12],
  [13, 13],
  [14, 14],
  [15, 15],
  [16, 16]
]

comment_readings_list.each do |comment_readings|
  CommentReading.create(comment_id: comment_readings[0],
                         reading_id: comment_readings[1])
end
