# frozen_string_literal: true

require_relative '_support'

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

describe Hexa::Pipes::Seq do
  before do
    @pipeline = TestPipeline.new
  end

  specify :call do
    out = @pipeline.call('John')
    assert_equal 'Hello, John... Bye.', out.result
  end

  specify :to_proc do
    result = %w[Jake Jane].map(&@pipeline).map(&:result)
    expected = ['Hello, Jake... Bye.', 'Hello, Jane... Bye.']
    assert_equal expected, result
  end
end
