require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  test "attributes can't be blank" do
    user = User.new(login: 'userKEKW', password: 'Password', password_confirmation: 'Password', company: false)
    user.save

    student = Student.new do |t|
      t.fullname = ''
      t.departament = ''
      t.group = ''
      t.wish = ''
      t.user_id = 1
    end

    assert student.invalid?

    student.fullname = 'name'
    assert student.invalid?

    student.departament = 'departament'
    assert student.invalid?

    student.group = 'group'
    assert student.invalid?

    student.wish = 'wish'
    assert student.valid?
  end

  test 'student should belong to user' do
    student = Student.new do |t|
      t.fullname = '123'
      t.departament = '123'
      t.group = '123'
      t.wish = '123'
      t.user_id = 1
    end
    assert student.invalid?

    user = User.new(login: 'userKEKW', password: 'Password', password_confirmation: 'Password', company: false)
    user.save
    student = Student.new do |t|
      t.fullname = '123'
      t.departament = '123'
      t.group = '123'
      t.wish = '123'
      t.user_id = 1
    end
    assert student.valid?
  end
end
