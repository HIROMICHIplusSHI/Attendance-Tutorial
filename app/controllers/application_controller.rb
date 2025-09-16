class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  $days_of_the_week = %w{日 月 火 水 木 金 土} 

  private

  # ページ出力前に1ヶ月分のデータの存在を確認・セットします
  def set_one_month 
    puts "🔧 DEBUG: set_one_month called"
    puts "🔧 params[:date]: #{params[:date]}"
    begin
      @first_day = params[:date].nil? ? Date.current.beginning_of_month : params[:date].to_date
      @last_day = @first_day.end_of_month
      puts "🔧 First day: #{@first_day}, Last day: #{@last_day}"
      one_month = [*@first_day..@last_day]
    rescue => e
      puts "🚨 ERROR in set_one_month: #{e.message}"
      puts "🚨 Backtrace: #{e.backtrace.first(3).join(', ')}"
      raise e
    end
    
    # ユーザーに紐付く一ヶ月分のレコードを検索し取得
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)

    unless one_month.count == @attendances.count
      ActiveRecord::Base.transaction do
        # 既存の勤怠レコードの日付を取得
        existing_dates = @attendances.pluck(:worked_on)
        # まだレコードがない日付のみ作成
        missing_days = one_month.reject { |day| existing_dates.include?(day) }
        missing_days.each { |day| @user.attendances.create!(worked_on: day) }
      end
      @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end

  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end

  def set_user
    @user = User.find(params[:id])
  end

  # ログイン済みのユーザーか確認します。
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end

  # アクセスしたユーザーが現在ログインしているユーザーか確認します。
  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  # システム管理権限所有かどうか判定します。
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
