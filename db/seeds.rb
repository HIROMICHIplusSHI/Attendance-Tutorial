# Sample users for development
users = [
  { name: "Taro Yamada", email: "taro@example.com", password: "password123" },
  { name: "Hanako Sato", email: "hanako@example.com", password: "password123" },
  { name: "Jiro Tanaka", email: "jiro@example.com", password: "password123" },
  { name: "Sachiko Watanabe", email: "sachiko@example.com", password: "password123" },
  { name: "Kenji Nakamura", email: "kenji@example.com", password: "password123" }
]

users.each do |user_data|
  user = User.find_or_create_by!(email: user_data[:email]) do |u|
    u.name = user_data[:name]
    u.password = user_data[:password]
  end
  puts "✅ User: #{user.name} (#{user.email}) - ID: #{user.id}"
end

puts "📊 Total users: #{User.count}"
