  # frozen_string_literal: true

require 'test_helper'
require 'uri'
require 'pry-byebug'

# class Email < Hexa::Values::Str
#   validate(:pattern, URI::MailTo::EMAIL_REGEXP)
# end

Email = Hexa::Values::Str[pattern: URI::MailTo::EMAIL_REGEXP]

class BaseRecord < Hexa::Values::Record
  def to_json(options = {})
    Hexa::Json.generate(self, **options)
  end
end

class Person < BaseRecord
  attr_reader :first_name, :last_name, :dob

  attr_annotate :first_name, Str | Null | Undefined, desc: 'First Name'
  attr_annotate :last_name, Str | Null | Undefined, desc:  'Last Name'
  attr_annotate :dob, Dt | Undefined, desc: 'Date of Birth'
end

class User < Person
  attr_reader :email, :tags

  attr_annotate :email, Email | Undefined, desc: 'Email'
  attr_annotate :tags, List[Str, prefix_items: [Int], min_len: 3, uniq: true] | Undefined, desc: 'Tags'

  validate(:min_tags, 2) { |val, min_tags| !val.attribute_defined?(:tags) || val.tags.size >= min_tags }
end

describe Hexa::Values::RecordMixin do
  describe 'class' do
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
      user = User.new

      refute_predicate user, :first_name_defined?
      refute_predicate user, :last_name_defined?
      refute_predicate user, :dob_defined?
      refute_predicate user, :email_defined?
      refute_predicate user, :tags_defined?
    end
  end

  describe 'instance' do
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

  describe 'euqality' do
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

    it 'checks equality' do
      assert_equal @u1, @u2
      refute_equal @u1, @u3
      refute_equal @u3, @u4
    end
  end

  specify :to_json do
    json = '{firstName:"John",lastName:"Doe",dob:"2001-01-01",email:"john@google.com",tags:[1,"aaa","bbb","ccc"]}'
    user = User.new(first_name: 'John', last_name: 'Doe', dob: '2001-01-01',
                    email: 'john@google.com', tags: [1] + %w[aaa bbb ccc])

    assert_equal json, user.to_json
  end
end
