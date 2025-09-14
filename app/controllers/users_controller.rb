class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:index, :show, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.page(params[:page]).per(30)  # ページネーション：1ページ30件
  end
  
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
      log_in @user # 保存成功後、ログインします。
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user  # 詳細画面へ遷移
    else
      Rails.logger.warn "⚠️ 登録失敗: #{@user.errors.full_messages}"
      flash.now[:danger] = '新規作成に失敗しました。'
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    Rails.logger.debug "🗑️ 削除処理開始: User ID #{@user.id}, Name: #{@user.name}"
    
    if @user.destroy
      Rails.logger.info "✅ 削除成功: #{@user.name}さんを削除しました"
      flash[:success] = "#{@user.name}さんを削除しました。"
      redirect_to users_url
    else
      Rails.logger.error "❌ 削除失敗: #{@user.errors.full_messages}"
      flash[:danger] = "削除に失敗しました: #{@user.errors.full_messages.join(', ')}"
      redirect_to users_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end

  # ログイン済みか確認
  def logged_in_user
    unless logged_in?
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end

  # 正しいユーザーかどうかチェック
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # 管理者かどうか確認
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
