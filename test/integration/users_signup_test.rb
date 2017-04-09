require 'test_helper'

# integration tests for User sign up
class UsersSignupTest < ActionDispatch::IntegrationTest

  test 'invalid sign up information' do
    get signup_path

    assert_no_difference 'User.count' do
      post signup_path params: {user: {
          name: '',
          email: 'email@invalid',
          password: '123456',
          password_confirmation: '789012'
      }}
    end

    assert_template 'users/new'
    assert_select 'div.field_with_errors', count: 6
  end

  test 'valid sign up' do
    get signup_path

    assert_difference 'User.count', 1 do
      post signup_path params: {user: {
          name: 'Kaja',
          email: 'email@val.id',
          password: '123456',
          password_confirmation: '123456'
      }}
    end

    follow_redirect!
    assert_template 'users/show'
    # assert_select 'div.alert-success', count: 1
    assert_not flash.empty?
  end
end
