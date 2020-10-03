class BookSerializer < ActiveModel::Serializer
  attributes :id, :author, :image

  # :average_rating_of_book, :content_rating_of_book, :recomment_rating_of_book,
  
  # :total_reviews

  has_many :reviews

  # def average_rating_of_book
  #   object.reviews.count == 0 ? 0 : object.reviews.average(:average_rating).round(1)
  # end

  # def content_rating_of_book
  #   object.reviews.count == 0 ? 0 : object.reviews.average(:content_rating).round(1)
  # end

  # def recomment_rating_of_book
  #   object.reviews.count == 0 ? 0 : object.reviews.average(:recomment_rating).round(1)
  # end

  # def total_reviews
  #   object.reviews.count
  # end
end
