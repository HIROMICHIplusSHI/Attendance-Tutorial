module UsersHelper

  # 勤怠基本情報を指定のフォーマットで返します。
  # 時間を10進数形式で返す（例：7.50時間）
  def format_basic_info(time)
    # 日付部分を無視して、時刻部分のみから計算
    hour = time.hour
    min = time.min
    format("%.2f", hour + (min / 60.0))
  end
end
