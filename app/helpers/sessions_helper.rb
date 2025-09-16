# app/helpers/sessions_helper.rb
module SessionsHelper
  # ログイン処理
  def log_in(user)
    session[:user_id] = user.id
  end

  # ユーザーのセッションを永続的にする
  def remember(user)
    user.remember  # Userモデルのrememberメソッドを呼ぶ
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 現在のユーザーを返す（いる場合）
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user  # セッションを復活させる
        @current_user = user
      end
    end
  end

  # ログイン状態の確認
  def logged_in?
    !current_user.nil?
  end

  # 永続的セッションを破棄
  def forget(user)
    user.forget  # DBのremember_digestをnilに
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウト（既存メソッドを更新）
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # 渡されたユーザーがログイン中のユーザーならtrue
  def current_user?(user)
    user == current_user
  end

  # アクセスしようとしたURLを記憶
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  # 記憶されたURL（もしくはデフォルト値）にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
end
