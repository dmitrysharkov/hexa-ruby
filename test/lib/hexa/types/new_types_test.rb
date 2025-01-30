# frozen_string_literal: true

require_relative '_support'

class MyContext < Hexa::Context
  UserId = str

  Dt = type(Date) do |val, cls|
    d = Date.parse(val) if val.is_a?(String)
    cls.new(d.year, d.month, d.day)
  rescue Date::Error
    nil
  end

  Point = int * int * str * Dt # tuple
  MyChoice = int | str | Dt

  FirstName = str & 1 & 2 & 3
  LastName = str

  FullName = FirstName * LastName

  PositiveInt = int & gt[0]

  Point = -PositiveInt * PositiveInt * PositiveInt
end


describe Hexa::Context do
  it do
    x = MyContext::UserId.new('Hello')

    assert x.is_a?(String)
    assert_equal 'Hello', x
  end

  it do
    x = MyContext::Dt.new(2020, 1, 1)

    assert x.is_a?(Date)
    assert_equal Date.new(2020, 1, 1), x
  end

  it do
    assert Hexa::Int < Integer
    assert Hexa::Int < Hexa::Value
  end

  it do
    assert MyContext::MyChoice < Hexa::Choice
    assert_equal 3, MyContext::MyChoice.items.size
    assert_equal Hexa::Int, MyContext::MyChoice.items[0]
    assert_equal Hexa::Str, MyContext::MyChoice.items[1]
    assert_equal MyContext::Dt, MyContext::MyChoice.items[2]
  end

  it do
    assert MyContext::Point < Hexa::Tuple
    assert_equal 4, MyContext::Point.items.size
    assert_equal Hexa::Int, MyContext::Point.items[0]
    assert_equal Hexa::Int, MyContext::Point.items[1]
    assert_equal Hexa::Str, MyContext::Point.items[2]
    assert_equal MyContext::Dt, MyContext::Point.items[3]
  end

  it do
    #binding.pry
    d = MyContext::Dt.cast('2020-01-01')
    assert_equal Date.new(2020, 1, 1), d
    assert_equal MyContext::Dt.new(2020, 1, 1), d
    assert_equal MyContext::Dt, d.class
  end

  it do
    assert_equal 3, MyContext::FirstName.constraints.size
    assert_equal [1, 2, 3], MyContext::FirstName.constraints

    assert_equal 0, Hexa::Str.constraints.size
    assert_equal [], Hexa::Str.constraints
    assert_nil Hexa::Str.key

    assert_equal :first_name, MyContext::FirstName.key
    refute_predicate MyContext::FirstName, :prototype?
    assert_equal Hexa::Str, MyContext::FirstName.prototype
  end
end

