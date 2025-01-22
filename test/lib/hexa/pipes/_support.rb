# frozen_string_literal: true

require 'minitest/autorun'
require 'hexa'
require 'pry-byebug'

class TestPipeline < Hexa::Pipes::Seq
  input String

  bind :hello
  map :bye

  def hello(payload)
    Success.new("Hello, #{payload}.")
  end

  def bye(payload)
    "#{payload}.. Bye."
  end
end

