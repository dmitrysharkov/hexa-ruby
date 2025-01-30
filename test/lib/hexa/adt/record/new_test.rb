# frozen_string_literal: true

require_relative '_support'

describe Hexa::Adt::RecordMixin do
  xdescribe 'class' do
    it 'lists all attributes names' do
      assert_equal %i[first_name last_name dob email tags], User.attributes.map(&:name)
    end

    it 'creates and instance from hash' do
      user = User.new(first_name: 'John', last_name: 'Doe', email: 'john@google.com',
                      dob: '2001-01-01', tags: [1] + %w[aaa bbb ccc])

      assert_equal 'John', user.first_name
      assert_equal 'Doe', user.last_name
      assert_equal Date.new(2001, 1, 1), user.dob
      assert_equal 'john@google.com', user.email
      assert_equal [1] + %w[aaa bbb ccc], user.tags

      assert_predicate user, :first_name_defined?
      assert_predicate user, :last_name_defined?
      assert_predicate user, :dob_defined?
      assert_predicate user, :email_defined?
      assert_predicate user, :tags_defined?
    end

    it 'creates and instance from array' do
      user = User.new('John', 'Doe', '2001-01-01', 'john@google.com', [1] + %w[aaa bbb ccc])

      assert_equal 'John', user.first_name
      assert_equal 'Doe', user.last_name
      assert_equal Date.new(2001, 1, 1), user.dob
      assert_equal 'john@google.com', user.email
      assert_equal [1] + %w[aaa bbb ccc], user.tags

      assert_predicate user, :first_name_defined?
      assert_predicate user, :last_name_defined?
      assert_predicate user, :dob_defined?
      assert_predicate user, :email_defined?
      assert_predicate user, :tags_defined?
    end

    it 'creates and instance from hash with str keys ' do
      user = User.new(**{ 'first_name' => 'John', 'last_name' => 'Doe', 'email' => 'john@google.com',
                          'dob' => '2001-01-01', 'tags' => [1] + %w[aaa bbb ccc]})

      assert_equal 'John', user.first_name
      assert_equal 'Doe', user.last_name
      assert_equal Date.new(2001, 1, 1), user.dob
      assert_equal 'john@google.com', user.email
      assert_equal [1] + %w[aaa bbb ccc], user.tags

      assert_predicate user, :first_name_defined?
      assert_predicate user, :last_name_defined?
      assert_predicate user, :dob_defined?
      assert_predicate user, :email_defined?
      assert_predicate user, :tags_defined?
    end

    it 'creates with undefined values' do
      user = User.new('John', 'Doe')

      assert_equal 'John', user.first_name
      assert_equal 'Doe', user.last_name

      assert_predicate user, :first_name_defined?
      assert_predicate user, :last_name_defined?
      refute_predicate user, :dob_defined?
      refute_predicate user, :email_defined?
      refute_predicate user, :tags_defined?
    end
  end
end
