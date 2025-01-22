# frozen_string_literal: true

require_relative '_support'

describe 'Hexa::Adt::RecordMixin' do
  it do
    json = '{firstName:"John",lastName:"Doe",dob:"2001-01-01",email:"john@google.com",tags:[1,"aaa","bbb","ccc"]}'
    user = User.new(first_name: 'John', last_name: 'Doe', dob: '2001-01-01',
                    email: 'john@google.com', tags: [1] + %w[aaa bbb ccc])

    assert_equal json, user.to_json
  end
end
