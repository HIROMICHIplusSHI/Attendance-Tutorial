class Attendance < ApplicationRecord
  validates :user_id, presence: true
  validates :check_in, presence: true
  belongs_to :user
end