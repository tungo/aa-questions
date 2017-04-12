class Reply < ModelBase
  attr_accessor :body
  attr_reader :question_id, :parent_id, :user_id, :id

  TABLE_NAME = :replies

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
