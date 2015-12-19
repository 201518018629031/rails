class BlogInfo < ActiveRecord::Base
  validates :name, length: {minimum: 2, maximum: 20}
  validates :email, format: {with: /\A[a-zA-Z0-9\-]+@[a-zA-Z0-9-]+\.(org|com|cn|io|net|cc|me)\z/}

end
