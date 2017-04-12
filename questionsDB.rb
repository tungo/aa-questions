require 'sqlite3'
require 'singleton'


class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class ModelBase
  TABLE_NAME = nil

  def self.find_by_id(id)
    results = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        #{self::TABLE_NAME}
      WHERE
        id = ?;
    SQL
    return nil if results.empty?

    self.new(results.first)
  end

  def self.all
    results = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self::TABLE_NAME}
    SQL

    results.map { |result| self.new(result) }
  end

  def self.where(options)
    options_string = options.map { |k, v| "#{k} = '#{v}'" }.join(' AND ')

    results = QuestionsDatabase.instance.execute(<<-SQL)
      SELECT
        *
      FROM
        #{self::TABLE_NAME}
      WHERE
        #{options_string}
    SQL

    results.map { |result| self.new(result) }
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
    vars = self.instance_variables.map { |var| var.to_s[1..-1] }
    values = vars.map { |var| eval("self.#{var}") }
    vars.delete('id')

    QuestionsDatabase.instance.execute(<<-SQL, values)
      UPDATE
        #{self.class::TABLE_NAME}
      SET
        #{vars.map { |var| "#{var} = ?" }.join(', ') }
      WHERE
        id = ?
    SQL
    @id
  end

  def insert
    vars = self.instance_variables.map { |var| var.to_s[1..-1] }
    vars.delete('id')
    values = vars.map { |var| eval("self.#{var}") }

    QuestionsDatabase.instance.execute(<<-SQL, values)
      INSERT INTO
        #{self.class::TABLE_NAME}(#{vars.join(', ')})
      VALUES
        (#{vars.map { '?' }.join(', ')});
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end
end

require_relative 'question'
require_relative 'user'
require_relative 'reply'
require_relative 'question_like'
require_relative 'question_follow'
