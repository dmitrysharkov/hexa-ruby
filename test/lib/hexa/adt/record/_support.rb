# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/skip_dsl'
require 'hexa'
require 'uri'
require 'pry-byebug'

Email = Hexa::Adt::String[pattern: URI::MailTo::EMAIL_REGEXP]
FirstName = Hexa::Adt::String[]
LastName = Hexa::Adt::String[]
StrTag = Hexa::Adt::String[]
IntTag = Hexa::Adt::Int[]
Tags = Hexa::Adt::List[StrTag, prefix_items: [IntTag], min_len: 3, uniq: true]
DateOfBirth = Hexa::Adt::Date[]

class BaseRecord < Hexa::Adt::Record
  def to_json(options = {})
    Hexa::Json.generate(self, **options)
  end
end

class Person < BaseRecord
  attr_reader :first_name, :last_name, :dob

  attr_annotate :first_name, FirstName, desc: 'First Name'
  attr_annotate :last_name, LastName, desc: 'Last Name'
  attr_annotate :dob, DateOfBirth | Undefined, desc: 'Date of Birth'
end

class User < Person
  attr_reader :email, :tags

  attr_annotate :email, Email | Undefined, desc: 'Email'
  attr_annotate :tags,  Tags | Null | Undefined, desc: 'Tags'

  validate(:min_tags, 2) { |val, min_tags| !val.attribute_defined?(:tags) || val.tags.size >= min_tags }
end
