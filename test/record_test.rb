# frozen_string_literal: true

require 'minitest/autorun'
require 'hexa'
require 'pry-byebug'

class User
  include Hexa::Values::ObjectMixin

  attr :first_name, Str | Null | Undefined
  attr :last_name, Str | Null | Undefined
end

describe Hexa::Values::ObjectMixin do
  describe 'class' do
    it 'lists all attributes names' do
      assert_equal %i[first_name last_name], User.attributes.map(&:name)
    end

    it 'creates and instance from hash' do
      user = User.new(first_name: 'John', last_name: 'Doe')

      assert_equal 'John', user.first_name
      assert_equal 'Doe', user.last_name
    end

    it 'creates and instance from array' do
      user = User.new('John', 'Doe')

      assert_equal 'John', user.first_name
      assert_equal 'Doe', user.last_name
    end

    it 'creates and instance from hash with str keys ' do
      user = User.new(**{ 'first_name' => 'John', 'last_name' => 'Doe' })

      assert_equal 'John', user.first_name
      assert_equal 'Doe', user.last_name
      assert_predicate user, :first_name_defined?
      assert_predicate user, :last_name_defined?
    end

    it 'creates with undefined values' do
      user = User.new

      refute_predicate user, :first_name_defined?
      refute_predicate user, :last_name_defined?
    end
  end

  describe 'instance' do
    before do
      @instance = User.new(first_name: 'John', last_name: 'Doe')
    end

    it :deconstruct do
      assert_equal %w[John Doe], @instance.deconstruct
    end

    it :deconstruct_keys do
      assert_equal({ first_name: 'John', last_name: 'Doe' }, @instance.deconstruct_keys(%i[first_name last_name]))
    end
  end
end
