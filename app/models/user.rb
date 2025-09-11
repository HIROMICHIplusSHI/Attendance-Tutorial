class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, uniqueness: true
  # length: { maximum: 100 } → メールアドレスで100文字超えることある？不要
  # format: → 完璧な検証は不可能。最小限でOK  has_many :attendances
  has_secure_password
  validates :password, presence: true, length: { minimum: 8 }
end

class Attendance < ApplicationRecord
  validates :user_id, presence: true
  validates :check_in, presence: true
  belongs_to :user
end
