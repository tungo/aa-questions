require 'sqlite3'
require 'singleton'

require_relative 'question'
require_relative 'user'
require_relative 'reply'
require_relative 'like'
require_relative 'follow'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end
