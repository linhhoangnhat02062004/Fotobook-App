# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create admin user
admin_user = User.find_or_create_by(email: 'admin@fotobook.com') do |user|
  user.first_name = 'Admin'
  user.last_name = 'User'
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.admin = true
  user.status = 'active'
end

puts "Admin user created: #{admin_user.email}"

# Create some regular users
5.times do |i|
  user = User.find_or_create_by(email: "user#{i+1}@example.com") do |u|
    u.first_name = "User#{i+1}"
    u.last_name = "Example"
    u.password = 'password123'
    u.password_confirmation = 'password123'
    u.admin = false
    u.status = 'active'
  end
  puts "User created: #{user.email}"
end

puts "Seed data created successfully!"

# Tạo photos mẫu
puts "Đang tạo photos..."

photo1 = Photo.create!(
  title: 'Ảnh đẹp 1',
  description: 'Đây là ảnh đẹp đầu tiên',
  sharing_mode: 'public',
  user: user1
)

photo2 = Photo.create!(
  title: 'Ảnh gia đình',
  description: 'Ảnh chụp cùng gia đình',
  sharing_mode: 'public',
  user: user1
)

photo3 = Photo.create!(
  title: 'Du lịch Sapa',
  description: 'Ảnh chụp khi đi du lịch Sapa',
  sharing_mode: 'public',
  user: user2
)

photo4 = Photo.create!(
  title: 'Ảnh công việc',
  description: 'Ảnh tại nơi làm việc',
  sharing_mode: 'private',
  user: user2
)

puts "Đã tạo #{Photo.count} photos"

# Tạo albums mẫu
puts "Đang tạo albums..."

album1 = Album.create!(
  title: 'Album Gia Đình',
  description: 'Những khoảnh khắc đẹp cùng gia đình',
  sharing_mode: 'public',
  user: user1
)

album2 = Album.create!(
  title: 'Du Lịch 2024',
  description: 'Những chuyến du lịch trong năm 2024',
  sharing_mode: 'public',
  user: user2
)

album3 = Album.create!(
  title: 'Album Riêng Tư',
  description: 'Những ảnh riêng tư của tôi',
  sharing_mode: 'private',
  user: user1
)

# Liên kết photos với albums
album1.photos << [photo1, photo2]
album2.photos << [photo3]
album3.photos << [photo1]

puts "Đã tạo #{Album.count} albums"

puts "Hoàn thành! Dữ liệu mẫu đã được tạo."
puts "Bạn có thể đăng nhập với:"
puts "- Email: user1@example.com, Password: password123"
puts "- Email: user2@example.com, Password: password123" 
puts "- Email: admin@example.com, Password: admin123"
puts ""
puts "Để test tab albums, truy cập:"
puts "- http://localhost:3000/users/1 (user1)"
puts "- http://localhost:3000/users/2 (user2)"
