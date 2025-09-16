# app/controllers/attendances_controller.rb
class AttendancesController < ApplicationController
  before_action :set_user_from_user_id, only: [:edit_one_month, :update_one_month]
  before_action :logged_in_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: :edit_one_month

  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    
    if @attendance.started_at.nil?
      # その日の現在時刻で打刻
      current_time = Time.current
      attendance_time = Time.zone.local(
        @attendance.worked_on.year,
        @attendance.worked_on.month,
        @attendance.worked_on.day,
        current_time.hour,
        current_time.min,
        0
      )
      if @attendance.update(started_at: attendance_time)
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      # その日の現在時刻で打刻
      current_time = Time.current
      attendance_time = Time.zone.local(
        @attendance.worked_on.year,
        @attendance.worked_on.month,
        @attendance.worked_on.day,
        current_time.hour,
        current_time.min,
        0
      )
      if @attendance.update(finished_at: attendance_time)
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end

  def edit_one_month
    # @userと@attendancesはbefore_actionで設定済み
  end

  def update_one_month
    Rails.logger.debug "🔧 DEBUG: Full params = #{params.inspect}"
    Rails.logger.debug "🔧 DEBUG: User params = #{params[:user]&.inspect}"
    
    attendance_params = attendances_params
    Rails.logger.debug "🔧 DEBUG: attendances_params = #{attendance_params.inspect}"
    
    if attendance_params.nil?
      flash[:danger] = "勤怠データが送信されていません。"
      redirect_to edit_one_month_user_attendances_url(@user, date: params[:date])
      return
    end
    
    ActiveRecord::Base.transaction do
      attendance_params.each do |id, item|
        attendance = Attendance.find(id)
        
        # 時刻文字列をDateTimeに変換
        if item[:started_at].present?
          item[:started_at] = parse_time_to_datetime(attendance.worked_on, item[:started_at])
        end
        
        if item[:finished_at].present?
          item[:finished_at] = parse_time_to_datetime(attendance.worked_on, item[:finished_at])
        end
        
        Rails.logger.debug "🔧 Updating attendance #{id}: #{item.inspect}"
        attendance.update!(item)
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
    redirect_to user_url(@user, date: params[:date])
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to edit_one_month_user_attendances_url(@user, date: params[:date])
  end

  private

  def attendances_params
    params.require(:user).permit(attendances: [:started_at, :finished_at, :note])[:attendances]
  end

  # AttendancesController専用のユーザー取得メソッド
  def set_user_from_user_id
    @user = User.find(params[:user_id])
  end

  def admin_or_correct_user
    @user = User.find(params[:user_id]) if @user.blank?
    unless current_user?(@user) || current_user.admin?
      flash[:danger] = "編集権限がありません。"
      redirect_to(root_url)
    end  
  end

  # 時刻文字列をDateTimeに変換するヘルパーメソッド
  def parse_time_to_datetime(date, time_string)
    return nil if time_string.blank?
    
    # 時刻文字列を解析 (HH:MM形式を想定)
    hour, minute = time_string.split(':').map(&:to_i)
    
    # その日の指定された時刻でDateTimeオブジェクトを作成
    Time.zone.local(date.year, date.month, date.day, hour, minute, 0)
  rescue
    nil
  end
end
