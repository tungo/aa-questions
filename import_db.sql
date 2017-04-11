CREATE TABLE users(
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions(
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_follows(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  parent_id INTEGER,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (parent_id) REFERENCES replies(id)
);

CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
  users(fname, lname)
VALUES
  ('Tu', 'Go'),
  ('Nikita', 'Shalimov'),
  ('John', 'Man');

INSERT INTO
  questions(title, body, user_id)
VALUES
  ('How??','How do i?',1),
  ('Where?','Where am i?',3),
  ('What?', 'What is SQL?',3);

INSERT INTO
  question_follows(question_id, user_id)
VALUES
  (1,2),
  (1,3);

INSERT INTO
  question_likes(question_id, user_id)
VALUES
  (3,2),
  (2,1);

INSERT INTO
  replies(body, question_id, user_id, parent_id)
VALUES
  ('HERE.',2,1,NULL),
  ('AM I?',2,3,1);
