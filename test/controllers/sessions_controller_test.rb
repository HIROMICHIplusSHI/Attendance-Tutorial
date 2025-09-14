require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create!(
      name: 'Test User',
      email: "test_#{SecureRandom.hex(4)}@example.com",
      password: 'password',
      password_confirmation: 'password'
    )
  end

  test "should get login page" do
    get login_path
    assert_response :success
  end

  test "login with remember me checked should set remember digest" do
    post login_path, params: { session: { 
      email: @user.email, 
      password: 'password', 
      remember_me: '1' 
    }}
    
    assert_redirected_to @user
    
    # remember_digestが設定されているか確認
    @user.reload
    assert_not_nil @user.remember_digest
  end

  test "login with remember me unchecked should not set remember digest" do
    post login_path, params: { session: { 
      email: @user.email, 
      password: 'password', 
      remember_me: '0' 
    }}
    
    assert_redirected_to @user
    
    # remember_digestが設定されていないか確認
    @user.reload
    assert_nil @user.remember_digest
  end

  test "login with wrong password should show error" do
    post login_path, params: { session: { 
      email: @user.email, 
      password: 'wrong_password', 
      remember_me: '0' 
    }}
    
    assert_response :unprocessable_entity
    assert_not flash.empty?
  end

end
