# frozen_string_literal: true

require_relative '_support'

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

  specify :filter do
    filter = Hexa::Pipes::Filter.new { |val| val.include?('Jane') }
    result = %w[Jake Jane].map(&@pipeline).map(&filter).select(&Hexa::Pipes::Success).map(&:result)
    expected = ['Hello, Jane... Bye.']
    assert_equal expected, result
  end
end
