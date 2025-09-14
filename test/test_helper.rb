ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    
    # テスト用ログインヘルパーメソッド
    def log_in_as(user, password: 'password', remember_me: '1')
      # まずログインページを取得してCSRFトークンを準備
      get login_path
      post login_path, params: { session: { 
        email: user.email,
        password: password,
        remember_me: remember_me 
      }}
    end
    
    # ログイン状態確認ヘルパー
    def is_logged_in?
      !session[:user_id].nil?
    end
  end
end
