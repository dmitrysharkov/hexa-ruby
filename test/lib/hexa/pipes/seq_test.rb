# frozen_string_literal: true

require_relative '_support'

describe Hexa::Pipes::Seq do
  xit :call do
    pipeline = TestPipeline.new(%w[Jake John Jane])
    out = pipeline.call('John')

    assert_equal 'Hello, John... Bye.', out.result
    assert_equal 1, pipeline.counter
  end

  xit :to_proc do
    pipeline = TestPipeline.new(%w[Jake John Jane])
    result = %w[Jake Jane].map(&pipeline).map(&:result)
    expected = ['Hello, Jake... Bye.', 'Hello, Jane... Bye.']

    assert_equal expected, result
    assert_equal 2, pipeline.counter
  end

  xit :filter do
    pipeline = TestPipeline.new(%w[Jake John Jane])
    filter = Hexa::Pipes::Filter.new { |val| val.include?('Jane') }
    result = %w[Jake Jane].map(&pipeline).map(&filter).select(&Hexa::Pipes::Success).map(&:result)
    expected = ['Hello, Jane... Bye.']

    assert_equal 2, pipeline.counter
    assert_equal expected, result
  end

  xit :ret do
    pipeline = TestPipeline.new(%w[Jake John Jane])
    errors = %w[Jake Jane Peter].map(&pipeline).select(&Hexa::Pipes::Failure).map(&:error)
    assert_equal ['Access denied'], errors
    assert_equal 2, pipeline.counter
  end
end
