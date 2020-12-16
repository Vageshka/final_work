require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(login: 'userKEKW', password: 'Password', password_confirmation: 'Password', company: false)
  end

  test 'Pass = pass_confirm' do
    @user.password_confirmation = 'wrong'
    assert @user.invalid?
    @user.password_confirmation = 'Password'
    assert @user.valid?
  end

  test 'valid login' do
    ['#-bad', '$-what?', 'why this', 'to_long' * 10].each do |str|
      @user.login = str
      assert @user.invalid?
    end
  end

  test 'valid presence of login' do
    @user.login = ' ' * 10
    assert @user.invalid?
  end

  test 'valid presence of password' do
    @user.password = ' ' * 10
    @user.password_confirmation = ' ' * 10
    assert @user.invalid?
  end

  test 'password should have at least one the title char' do
    @user.password = 'password'
    @user.password_confirmation = 'password'
    assert @user.invalid?
  end
end
