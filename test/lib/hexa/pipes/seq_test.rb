# frozen_string_literal: true

require_relative '_support'

class TestPipeline < Hexa::Pipes::Seq
  payload String

  bind :hello
  map :bye

  def hello(payload)
    Success.new("Hello, #{payload}.")
  end

  def bye(payload)
    "#{payload}.. Bye."
  end
end

describe Hexa::Pipes::Seq do
  it do
    pipeline = TestPipeline.new
    out = pipeline.call('John')
    assert_equal 'Hello, John... Bye.', out.result
  end
end
