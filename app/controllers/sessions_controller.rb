class SessionsController < ApplicationController
  def new
  end

  def create
    Rails.logger.debug "🔐 ログイン試行開始"
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      Rails.logger.info "✅ ログイン成功: #{user.name} (#{user.email})"
      # ログイン後にユーザー情報ページにリダイレクトします。
      log_in user
      redirect_to user
    else
      Rails.logger.warn "❌ ログイン失敗: #{params[:session][:email]}"
      flash.now[:danger] = '認証に失敗しました。'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end
end
