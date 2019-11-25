
#User

User.create!(name:  "admin",
             email: "admin@gmail.com",
             password:              "123456",
             password_confirmation: "123456",
             role: 1)
30.times do |n|
  name  = Faker::Name.name
  email = "user-#{n+1}@gmail.com"
  password = "123456"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               role: 2)
end
i =1
#Author
10.times do |n|
  name  = Faker::Name.name
  email = "author-#{n+1}@gmail.com"
  info = Faker::Lorem.paragraph(6)
  # password = "password"
  image = File.open("#{Rails.root}/app/assets/images/authors/#{i}.jpg")
  i = i+1
  Author.create!(name:  name,
               email: email,
               info: info,
               author_img:  image)
end
a=0
#Books
j =1 
authors = Author.all
authors.each do |author|
  3.times do |n|
    name = Faker::Book.title
    publisher = Faker::Book.publisher
    quantity = 100
    page = rand(10..1000)
    content = Faker::Lorem.paragraphs(2)
    c =""
    content.map{|i| c += " " + i}
    image = File.open("#{Rails.root}/app/assets/images/books/#{j}.jpg")
    j = j +1
    author.books.create!(name: name, quantity: quantity, publisher: publisher,page: page, book_img: image, content: c)
  end	
end

Category
categories = ["Textbook","Novel", "Manga","History", "Scientist", "Politic", "Cultural", "Computer", "Technical", "Geography"]
categories.each do |category|
	Category.create!(name: category)
end

#Bookcategory

books = Book.all
books.each do |book|
  book.categories  << Category.all[rand(10)]
end

#LikeBookUser
# user1 = User.first
# user2 = User.second
# books = Book.all
# likebook = books[1..20]
# likebook.each { |book| user1.like_book(book) }
# likebook = books[15..30]
# likebook.each { |book| user2.like_book(book)}

# #Review
# # users = User.all
# # users.each do |user|
# #     rating = rand(1..5)
# #     content = Faker::Quotes::Shakespeare.as_you_like_it_quote 
# #     book = Book.all[rand(Book.all.count)]
# #     Review.create!(rating: rating,content: content, user_id: user.id, book_id: book.id)
# # end

# #User_Follow_User
# users = User.all
# user  = users.first
# following = users[2..30]
# followers = users[3..30]
# following.each { |followed| user.follow(followed) }
# followers.each { |follower| follower.follow(user) }

# #User_Follow_Book
# user1 = User.first
# user2 = User.second
# books  = Book.all
# authors = Author.all
# following_book = books[10..20]
# following_author = authors[15..30]
# following_book.each { |book| user1.follow_book(book)}
# following_author.each { |author| user1.follow_author(author)}
# following_book.each { |book| user2.follow_book(book)}
# following_author.each { |author| user2.follow_author(author)}

