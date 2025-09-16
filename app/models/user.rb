class User < ApplicationRecord
  has_many :attendances, dependent: :destroy
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
                    
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  has_secure_password
  #新規作成時：passwordが空ならエラー
  #更新時：passwordを入力しなければ（nil）、バリデーションエラーにならない
  validates :password, presence: true, length: { minimum: 8 }, allow_nil: true

  validates :department, length: { in: 2..30 }, allow_blank: true
  # departmentは空でもOK、空でなければ2〜30文字
  validates :basic_time, presence: true
  validates :work_time, presence: true

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # 永続セッションのためにユーザーをデータベースに記憶
  def remember
    self.remember_token = User.new_token
    update!(remember_digest: User.digest(remember_token))
  end
  
  # トークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  # ユーザーのログイン情報を破棄
  def forget
    update!(remember_digest: nil)
  end

  # 管理者かどうかを判定
  def admin?
    admin
  end
end
