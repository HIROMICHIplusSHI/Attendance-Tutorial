# db/seeds.rb
User.find_or_create_by!(email: "admin@example.com") do |user|
  user.name = "管理者"
  user.password = "password"
  user.password_confirmation = "password"
  user.admin = true  # ここがポイント！
end

# 残りは一般ユーザー
50.times do |n|
  User.find_or_create_by!(email: "test#{n+1}@example.com") do |user|
    user.name = "テストユーザー#{n+1}"
    user.password = "password"
    user.password_confirmation = "password"
    # adminは指定しない = false
  end
end
