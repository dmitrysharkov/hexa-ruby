# frozen_string_literal: true

require_relative '_support'

describe 'Hexa::Adt::RecordMixin' do
  xdescribe 'eql' do
    before do
      @u1 = User.new(first_name: 'John', last_name: 'Doe', dob: '2001-01-01',
                     email: 'john@google.com', tags: [1] + %w[aaa bbb ccc])
      @u2 = User.new(first_name: 'John', last_name: 'Doe', dob: '2001-01-01',
                     email: 'john@google.com', tags: [1] + %w[aaa bbb ccc])
      @u3 = User.new(first_name: 'Jane', last_name: 'Doe', dob: '2001-01-01',
                     email: 'jane@google.com', tags: [1] + %w[aaa bbb ccc])
      @u4 = User.new(first_name: 'Jane', last_name: 'Doe', dob: '2001-01-01',
                     email: 'jane@google.com', tags: [1] + %w[aaa bbb ddd])
    end

    xit 'checks equality' do
      assert_equal @u1, @u2
      refute_equal @u1, @u3
      refute_equal @u3, @u4
    end
  end
end
