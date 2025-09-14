require 'test_helper'

class RememberMeTest < ActionDispatch::IntegrationTest
  def setup
    # テスト用のユーザーを直接作成（ユニークなメールアドレス）
    @user = User.create!(
      name: 'Test User',
      email: "test_#{SecureRandom.hex(4)}@example.com",
      password: 'password',
      password_confirmation: 'password'
    )
  end

  test "remember me checkbox checked should remember user" do
    # Remember meがチェックされた状態でログイン
    log_in_as(@user, remember_me: '1')
    
    # ログインできているか確認
    assert_redirected_to @user
    follow_redirect!
    assert_select "a[href=?]", logout_path
    
    # remember_digestが設定されているか確認
    assert_not_nil cookies[:remember_token]
    @user.reload
    assert_not_nil @user.remember_digest
    
    Rails.logger.info "✅ Remember me ON: クッキー設定確認"
  end

  test "remember me checkbox unchecked should not remember user" do
    # Remember meがチェックされていない状態でログイン
    log_in_as(@user, remember_me: '0')
    
    # ログインできているか確認
    assert_redirected_to @user
    
    # remember_digestが設定されていないか確認
    assert_nil cookies[:remember_token]
    @user.reload
    assert_nil @user.remember_digest
    
    Rails.logger.info "✅ Remember me OFF: クッキー未設定確認"
  end

  test "user should stay logged in after browser restart when remember me is checked" do
    # Remember meでログイン
    log_in_as(@user, remember_me: '1')
    
    # セッションをクリア（ブラウザ再起動をシミュレート）
    session.delete(:user_id)
    
    # まだログイン状態を維持できているかテスト
    get root_path
    assert logged_in_via_cookie?
    
    Rails.logger.info "✅ ブラウザ再起動後もログイン維持確認"
  end

  test "user should not stay logged in after browser restart when remember me is not checked" do
    # Remember me無しでログイン
    log_in_as(@user, remember_me: '0')
    
    # セッションをクリア（ブラウザ再起動をシミュレート）
    session.delete(:user_id)
    
    # ログアウト状態になっているかテスト
    get root_path
    assert_not logged_in_via_cookie?
    
    Rails.logger.info "✅ ブラウザ再起動後ログアウト確認"
  end

  private

  # クッキー経由でログインしているかチェックするヘルパーメソッド
  def logged_in_via_cookie?
    !cookies[:remember_token].blank?
  end
end