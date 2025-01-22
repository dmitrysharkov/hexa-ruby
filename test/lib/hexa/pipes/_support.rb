# frozen_string_literal: true

require 'minitest/autorun'
require 'hexa'
require 'pry-byebug'

class TestPipeline < Hexa::Pipes::Seq
  attr_reader :counter

  input String

  bind :hello
  map :bye
  tee :count

  def initialize
    super
    @counter = 0
  end

  def hello(payload)
    Success.new("Hello, #{payload}.")
  end

  def bye(payload)
    "#{payload}.. Bye."
  end

  def count(_)
    @counter += 1
  end
end

