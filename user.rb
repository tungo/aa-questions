class User < ModelBase
  attr_accessor :fname, :lname
  attr_reader :id

  TABLE_NAME = :users

  def initialize(options)
    @fname = options['fname']
    @lname = options['lname']
    @id = options['id']
  end

  def authored_questions
    raise "#{self} not in database" unless @id
    Question.find_by_user_id(@id)
  end

  def authored_replies
    raise "#{self} not in database" unless @id
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    # total likes / number of questions
    res = QuestionsDatabase.instance.execute(<<-SQL, @id)
    SELECT
      COALESCE(
        COUNT(question_likes.user_id) /
        CAST(COUNT(DISTINCT questions.id) AS FLOAT), 0.0) AS karma
    FROM
      questions
    LEFT JOIN
      question_likes ON questions.id = question_likes.question_id
    WHERE
      questions.user_id = ?
    SQL

    res.first['karma']
  end
end
