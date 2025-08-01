# Fotobook

**User & Admin account for testing**
1. Admin:
- Email: admin@fotobook.com
- Password: password123

2. User:
- Email: linhhoangnhat26@gmail.com
- Password: 0393411584

**Demo**
https://drive.google.com/drive/folders/1dRXyeNOo0zirhJb90wme4skTq1uTn-JG

**Roles**
* Sign_up:

1. Guest
2. User
3. Admin

**Features**:
1. Authentication & Authorization
- Devise với signup/login/reset password
- 3 loại user: Guest, Normal User, Admin
- Admin dashboard với layout riêng

2. Photo Management
- CRUD Photos: Create, Read, Update, Delete
- Upload ảnh với CarrierWave
- Sharing mode: Public/Private
- Like/Unlike photos

3. Album Management
- CRUD Albums: Create, Read, Update, Delete
- Multiple image upload cho albums
- Like/Unlike albums
- Album với photos

4. Social Features
- Follow/Unfollow system
- Feeds: Hiển thị posts từ following users
- Discovery: Hiển thị tất cả public posts
- Search: Tìm kiếm photos/albums

5. Profile System
- Public Profile: Xem profile user khác
- My Profile: Profile cá nhân
- Edit Profile: Cập nhật thông tin + avatar

6. Admin Features
- Manage Users: CRUD users, set active/inactive
- Manage Photos: CRUD tất cả photos (paginate 40/page)
- Manage Albums: CRUD tất cả albums (paginate 20/page)
- Admin Dashboard: Thống kê tổng quan

7. UI/UX
- Responsive: Bootstrap layout
- Pagination: Kaminari gem
- Notifications: Flash messages
- Modal popups: Xem photos/albums
- PWA: Progressive Web App support
