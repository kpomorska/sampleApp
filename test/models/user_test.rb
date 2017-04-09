require 'test_helper'

# users models tests
class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: 'Example User', email: 'users@example.com', password:
        'foobar', password_confirmation: 'foobar')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = ''
    assert_not @user.valid?
  end

  test 'email should be present' do
    @user.email = ''
    assert_not @user.valid?
  end

  test 'name should not be too long' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end

  test 'email should not be too long' do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[users@example,com user_at_foo.org users.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test 'email addresses should be unique' do
    user_duplication = @user.dup
    user_duplication.email = @user.email.upcase
    @user.save
    assert_not user_duplication.valid?
  end

  test 'email addresses should be saved as lower-case' do
    mixed_case_email = 'FooBar@ExMaPle.coM'
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.email
  end

  test 'password should be present (not blank)' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end

  test 'password should be longer than 6 digits' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end
end
