class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    Rails.logger.info "🔍 User show: #{@user.name} (#{@user.email}) - ID: #{@user.id}"
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    Rails.logger.debug "受信params: #{params.inspect}"
    Rails.logger.debug "許可params: #{user_params.inspect}"
    if @user.save
      Rails.logger.info "✅ 登録成功: #{@user.id}"
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user  # 詳細画面へ遷移
    else
      Rails.logger.warn "⚠️ 登録失敗: #{@user.errors.full_messages}"
      flash.now[:danger] = '新規作成に失敗しました。'
      render 'new', status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
