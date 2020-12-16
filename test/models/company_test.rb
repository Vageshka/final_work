require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  test "attributes can't be blank" do
    user = User.new(login: 'userKEKW', password: 'Password', password_confirmation: 'Password', company: false)
    user.save

    company = Company.new do |t|
      t.name = ''
      t.vacancy = ''
      t.requirements = ''
      t.conditions = ''
      t.user_id = 1
    end

    assert company.invalid?

    company.name = 'name'
    assert company.invalid?

    company.vacancy = 'vacancy'
    assert company.invalid?

    company.requirements = 'requirements'
    assert company.invalid?

    company.conditions = 'conditions'
    assert company.valid?
  end

  test 'company should belong to user' do
    company = Company.new do |t|
      t.name = '123'
      t.vacancy = '123'
      t.requirements = '123'
      t.conditions = '123'
      t.user_id = 1
    end
    assert company.invalid?

    user = User.new(login: 'userKEKW', password: 'Password', password_confirmation: 'Password', company: false)
    user.save
    company = Company.new do |t|
      t.name = '123'
      t.vacancy = '123'
      t.requirements = '123'
      t.conditions = '123'
      t.user_id = 1
    end
    assert company.valid?
  end
end
