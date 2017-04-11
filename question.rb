class Question
  attr_accessor :title, :body, :user_id
  attr_reader :id

  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?;
    SQL
    return nil if results.empty?

    self.new(results.first)
  end

  def self.find_by_author_id(author_id)
    user = User.find_by_id(author_id)

    results = QuestionsDatabase.instance.execute(<<-SQL, user.id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?;
    SQL

    results.map { |result| self.new(result) }
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def initialize(options)
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
    @id = options['id']
  end

  def author
    User.find_by_id(@user_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end

  def save
    if @id
      update
    else
      insert
    end
  end

  private
  def update
    QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @user_id, @id)
      UPDATE
        questions
      SET
        title = ?,
        body = ?,
        user_id = ?
      WHERE
        id = ?;
    SQL
  end

  def insert
    QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @user_id)
      INSERT INTO
        questions(title, body, user_id)
      VALUES
        (?, ?, ?);
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end
end
