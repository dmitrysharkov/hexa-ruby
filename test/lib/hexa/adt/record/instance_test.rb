# frozen_string_literal: true

require_relative '_support'

describe 'Hexa::Adt::RecordMixin' do
  xdescribe 'instance' do
    before do
      @instance = User.new(first_name: 'John', last_name: 'Doe', email: 'john@google.com',
                           dob: '2001-01-01', tags: [1] + %w[aaa bbb ccc])
    end

    it :deconstruct do
      arr = ['John', 'Doe', Date.new(2001, 1, 1), 'john@google.com', [1] + %w[aaa bbb ccc]]
      assert_equal arr, @instance.deconstruct
    end

    it :deconstruct_keys do
      hash = { first_name: 'John', last_name: 'Doe', email: 'john@google.com', tags: [1] + %w[aaa bbb ccc] }

      assert_equal hash, @instance.deconstruct_keys(%i[first_name last_name email tags])
    end
  end
end
