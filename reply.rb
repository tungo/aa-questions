class Reply
  attr_accessor :body
  attr_reader :question_id, :parent_id, :user_id, :id

  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?;
    SQL
    return nil if results.empty?
    self.new(results.first)
  end

  def self.find_by_user_id(user_id)
    user = User.find_by_id(user_id)

    results = QuestionsDatabase.instance.execute(<<-SQL, user.id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?;
    SQL

    results.map { |result| self.new(result) }
  end

  def self.find_by_question_id(question_id)
    question = Question.find_by_id(question_id)

    return [] unless question

    results = QuestionsDatabase.instance.execute(<<-SQL, question.id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?;
    SQL

    results.map { |result| self.new(result) }
  end

  def initialize(options)
    @body = options['body']
    @question_id = options['question_id']
    @user_id = options['user_id']
    @parent_id = options['parent_id']
    @id = options['id']
  end

  def author
    User.find_by_id(@user_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    return nil unless @parent_id
    Reply.find_by_id(@parent_id)
  end

  def child_replies
    replies = QuestionsDatabase.instance.execute(<<-SQL, @id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_id = ?;
    SQL

    replies.map { |reply| self.class.new(reply) }
  end
end
