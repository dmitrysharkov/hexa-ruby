# frozen_string_literal: true

require_relative '_support'

describe Hexa::Pipes::Seq do
  specify :call do
    pipeline = TestPipeline.new
    out = pipeline.call('John')

    assert_equal 'Hello, John... Bye.', out.result
    assert_equal 1, pipeline.counter
  end

  specify :to_proc do
    pipeline = TestPipeline.new
    result = %w[Jake Jane].map(&pipeline).map(&:result)
    expected = ['Hello, Jake... Bye.', 'Hello, Jane... Bye.']

    assert_equal expected, result
    assert_equal 2, pipeline.counter
  end

  specify :filter do
    pipeline = TestPipeline.new
    filter = Hexa::Pipes::Filter.new { |val| val.include?('Jane') }
    result = %w[Jake Jane].map(&pipeline).map(&filter).select(&Hexa::Pipes::Success).map(&:result)
    expected = ['Hello, Jane... Bye.']

    assert_equal 2, pipeline.counter
    assert_equal expected, result
  end
end
