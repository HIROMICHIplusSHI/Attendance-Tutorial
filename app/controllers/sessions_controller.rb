class SessionsController < ApplicationController
  def new
  end

  def create
    Rails.logger.debug "🔐 ログイン試行開始"
    Rails.logger.debug "受信パラメータ: #{session_params.inspect}"
    
    user = User.find_by(email: session_params[:email].downcase)
    if user && user.authenticate(session_params[:password])
      Rails.logger.info "✅ ログイン成功: #{user.name} (#{user.email})"
      # ログイン後にユーザー情報ページにリダイレクトします。
      log_in user
      session_params[:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
    else
      Rails.logger.warn "❌ ログイン失敗: #{session_params[:email]}"
      flash.now[:danger] = '認証に失敗しました。'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?  # ← 二重ログアウト対策
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end

  private

  def session_params
    params.require(:session).permit(:email, :password, :remember_me)
  end
end
