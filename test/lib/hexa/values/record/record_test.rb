# frozen_string_literal: true

require 'test_helper'
require 'uri'
require 'pry-byebug'

class Email < Hexa::Values::Str
  validate(:pattern, URI::MailTo::EMAIL_REGEXP)
end

class BaseUser
  include Hexa::Values::RecordMixin

  attr :first_name, Str | Null | Undefined, desc: 'First Name'
  attr :last_name, Str | Null | Undefined, desc:  'Last Name'
end

class User < BaseUser
  attr :email, Email | Undefined, desc: 'Email'
  attr :tags, List.of(Str) | Undefined, desc: 'Tags'

  validate(:min_tags, 2) { |val, min_tags| !val.attribute_defined?(:tags) || val.tags.size >= min_tags }
end

describe Hexa::Values::RecordMixin do
  describe 'class' do
    it 'lists all attributes names' do
      assert_equal %i[first_name last_name email tags], User.attributes.map(&:name)
    end

    it 'creates and instance from hash' do
      user = User.new(first_name: 'John', last_name: 'Doe', email: 'john@google.com', tags: %w[aaa bbb ccc])

      assert_equal 'John', user.first_name
      assert_equal 'Doe', user.last_name
      assert_equal 'john@google.com', user.email
      assert_equal %w[aaa bbb ccc], user.tags

      assert_predicate user, :first_name_defined?
      assert_predicate user, :last_name_defined?
      assert_predicate user, :email_defined?
      assert_predicate user, :tags_defined?
    end

    it 'creates and instance from array' do
      user = User.new('John', 'Doe', 'john@google.com', %w[aaa bbb ccc])

      assert_equal 'John', user.first_name
      assert_equal 'Doe', user.last_name
      assert_equal 'john@google.com', user.email
      assert_equal %w[aaa bbb ccc], user.tags

      assert_predicate user, :first_name_defined?
      assert_predicate user, :last_name_defined?
      assert_predicate user, :email_defined?
      assert_predicate user, :tags_defined?
    end

    it 'creates and instance from hash with str keys ' do
      user = User.new(**{ 'first_name' => 'John', 'last_name' => 'Doe', 'email' => 'john@google.com',
                          'tags' => %w[aaa bbb ccc]})

      assert_equal 'John', user.first_name
      assert_equal 'Doe', user.last_name
      assert_equal 'john@google.com', user.email
      assert_equal %w[aaa bbb ccc], user.tags

      assert_predicate user, :first_name_defined?
      assert_predicate user, :last_name_defined?
      assert_predicate user, :email_defined?
      assert_predicate user, :tags_defined?
    end

    it 'creates with undefined values' do
      user = User.new

      refute_predicate user, :first_name_defined?
      refute_predicate user, :last_name_defined?
      refute_predicate user, :email_defined?
      refute_predicate user, :tags_defined?
    end
  end

  describe 'instance' do
    before do
      @instance = User.new(first_name: 'John', last_name: 'Doe', email: 'john@google.com', tags: %w[aaa bbb ccc])
    end

    it :deconstruct do
      assert_equal ['John', 'Doe', 'john@google.com', %w[aaa bbb ccc]], @instance.deconstruct
    end

    it :deconstruct_keys do
      hash = { first_name: 'John', last_name: 'Doe', email: 'john@google.com', tags: %w[aaa bbb ccc] }

      assert_equal hash, @instance.deconstruct_keys(%i[first_name last_name email tags])
    end
  end

  describe 'euqality' do
    before do
      @u1 = User.new(first_name: 'John', last_name: 'Doe', email: 'john@google.com', tags: %w[aaa bbb ccc])
      @u2 = User.new(first_name: 'John', last_name: 'Doe', email: 'john@google.com', tags: %w[aaa bbb ccc])
      @u3 = User.new(first_name: 'Jane', last_name: 'Doe', email: 'jane@google.com', tags: %w[aaa bbb ccc])
      @u4 = User.new(first_name: 'Jane', last_name: 'Doe', email: 'jane@google.com', tags: %w[aaa bbb ddd])
    end

    it 'checks equality' do
      assert_equal @u1, @u2
      refute_equal @u1, @u3
      refute_equal @u3, @u4
    end
  end

  specify :to_json do
    json = "{firstName:\"John\",lastName:\"Doe\",email:\"john@google.com\",tags:[\"aaa\"\"bbb\",\"ccc\"]}"
    user = User.new(first_name: 'John', last_name: 'Doe', email: 'john@google.com', tags: %w[aaa bbb ccc])

    assert_equal json, user.to_json
  end
end
