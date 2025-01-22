# frozen_string_literal: true

require 'minitest/autorun'
require 'hexa'
require 'pry-byebug'

class TestPipeline < Hexa::Pipes::Seq
  attr_reader :counter, :allowed_people

  input String

  ret :return_with_error
  bind :hello
  map :bye
  tee :count

  def initialize(allowed_people = nil)
    super()
    @counter = 0
    @allowed_people = allowed_people
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

  def return_with_error(person)
    return person unless allowed_people

    if allowed_people.include?(person)
      [person, nil]
    else
      [nil, 'Access denied']
    end
  end
end

