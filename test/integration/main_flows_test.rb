require 'test_helper'

class MainFlowsTest < ActionDispatch::IntegrationTest
  def setup
    @PATHS_FOR_COMPANIES = [main_companies_path, main_all_applications_path, main_pending_confirmations_path, main_approved_path]
    @PATHS_FOR_STUDENTS = [main_students_path, main_all_companies_path, main_choosed_companies_path, main_waiting_approval_path]
  end

  test 'unauthenticated user' do
    get root_path
    assert_response :success

    get main_new_path
    assert_response :success

    get session_new_path
    assert_response :success

    @PATHS_FOR_COMPANIES.each do |p|
      get p
      assert_response :redirect
    end

    @PATHS_FOR_STUDENTS.each do |p|
      get p
      assert_response :redirect
    end

    get files_path(id: 1)
    assert_response :redirect
  end

  test 'sign up error' do
    post main_create_path
    follow_redirect!
    assert_equal path, main_new_path
    assert_select 'div#error_explanation', true
    assert_select 'h2', '6 error prohibited this user from being saved:'
  end

  test 'sign in error' do
    post session_create_path
    follow_redirect!
    assert_equal path, session_new_path
    assert_select 'div#error_explanation', true
    assert_select 'h2', 'Неверная комбинация логин / пароль'
  end

  test "authenticated user can't signup and login" do
    post main_create_path, params: { login: 'student', password: 'Password', password_confirmation: 'Password', company: 'student' }
    post session_create_path, params: { login: 'student', password: 'Password' }

    get main_new_path
    assert_response :redirect

    get session_new_path
    assert_response :redirect
  end

  test "didn't fill in the information" do
    post main_create_path, params: { login: 'student', password: 'Password', password_confirmation: 'Password', company: 'student' }
    post session_create_path, params: { login: 'student', password: 'Password' }

    get main_students_path
    assert_response :success
    get main_students_path
    assert_select 'h2', 'Пожалуйста,', true
    assert_select 'p', 'заполните все поля на своей странице', true

    get main_all_companies_path
    assert_response :redirect

    get main_edit_path
    post main_edit_path, params: { fullname: 'name', departament: '1', group: '1', wish: 'idk' }
    assert_select 'h2', false
  end

  test 'Pages only for students' do
    post main_create_path, params: { login: 'company', password: 'Password', password_confirmation: 'Password', company: 'company' }
    post session_create_path, params: { login: 'company', password: 'Password' }
    post main_edit_path, params: { name: 'name', vacancy: 'vacancy', requirements: 'requirements', conditions: 'conditions' }

    @PATHS_FOR_STUDENTS.each do |p|
      get p
      unless '/ru' + p == main_students_path
        assert_response :redirect
        follow_redirect!
      end
      assert_select 'h2', 'Извините,'
    end
  end

  test 'Pages only for companies' do
    post main_create_path, params: { login: 'student', password: 'Password', password_confirmation: 'Password', company: 'student' }
    post session_create_path, params: { login: 'student', password: 'Password' }
    post main_edit_path, params: { fullname: 'name', departament: '1', group: '1', wish: 'idk' }

    @PATHS_FOR_COMPANIES.each do |p|
      get p
      unless '/ru' + p == main_companies_path
        assert_response :redirect
        follow_redirect!
      end
      assert_select 'h2', 'Извините,'
    end
  end

  test 'Student has already chosen a company' do
    post main_create_path, params: { login: 'student', password: 'Password', password_confirmation: 'Password', company: 'student' }
    post session_create_path, params: { login: 'student', password: 'Password' }
    post main_edit_path, params: { fullname: 'name', departament: '1', group: '1', wish: 'idk' }
    User.new(login: 'company', password: 'Password', password_confirmation: 'Password', company: true).save
    Company.new(name: 'name', vacancy: 'vacancy', requirements: 'requirements', conditions: 'conditions', user_id: 2).save
    Offer.new(student_id: 1, company_id: 1, stud_agree: true, comp_agree: true).save

    get main_students_path
    assert_response :success
    assert_select 'p', 'Вы уже выбрали компанию'
  end

  test 'Redirect student after successfully approval company' do
    post main_create_path, params: { login: 'student', password: 'Password', password_confirmation: 'Password', company: 'student' }
    post session_create_path, params: { login: 'student', password: 'Password' }
    post main_edit_path, params: { fullname: 'name', departament: '1', group: '1', wish: 'idk' }
    User.new(login: 'company', password: 'Password', password_confirmation: 'Password', company: true).save
    Company.new(name: 'name', vacancy: 'vacancy', requirements: 'requirements', conditions: 'conditions', user_id: 2).save
    Offer.new(student_id: 1, company_id: 1, comp_agree: true, stud_agree: false).save

    get main_waiting_approval_path
    assert_response :success
    post approve_path(id: 1)
    assert_response :redirect
    follow_redirect!
    assert_select 'p', 'Вы уже выбрали компанию'
  end
end
