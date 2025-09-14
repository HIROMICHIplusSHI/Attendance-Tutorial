# app/helpers/sessions_helper.rb
module SessionsHelper
  # ログイン処理
  def log_in(user)
    session[:user_id] = user.id
  end

  # 現在のユーザー
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  # ログイン状態の確認
  def logged_in?
    !current_user.nil?
  end

  # ログアウト処理
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
