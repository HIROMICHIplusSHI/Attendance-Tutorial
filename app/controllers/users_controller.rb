class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  
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

  def edit_basic_info
    @user = User.find(params[:id])

    respond_to do |format|
      format.html { render partial: 'users/edit_basic_info', locals: { user: @user } }
      format.turbo_stream
    end
  end

  def update_basic_info
    @user = User.find(params[:id])

    Rails.logger.debug "🔧 Basic info params: #{basic_info_params.inspect}"
    Rails.logger.debug "🔧 Before update - Department: #{@user.department}, Basic: #{@user.basic_time}, Work: #{@user.work_time}"

    if @user.update(basic_info_params)
      Rails.logger.info "✅ 基本情報更新成功: #{@user.name}"
      Rails.logger.debug "🔧 After update - Department: #{@user.department}, Basic: #{@user.basic_time}, Work: #{@user.work_time}"
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      Rails.logger.warn "❌ 基本情報更新失敗: #{@user.name}"
      Rails.logger.debug "🔧 Errors: #{@user.errors.full_messages}"
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" +
                       @user.errors.full_messages.join("<br>")
    end

    respond_to do |format|
      format.html { redirect_to users_url }
      format.turbo_stream
    end
  end

  private

  # 通常のユーザー編集用（本人が編集可能）
  def user_params
    params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
  end

  # 基本情報編集用（管理者のみ編集可能）
  def basic_info_params
    params.require(:user).permit(:department, :basic_time, :work_time)
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
