class Review < ApplicationRecord
  before_validation :parse_image
  before_save :calculate_average_rating
  belongs_to :user
  belongs_to :book

  counter_culture :book

  attr_accessor :picture

  has_attached_file :picture, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment :picture, presence: true
  do_not_validate_attachment_file_type :picture

  private

  def parse_image
    image = Paperclip.io_adapters.for(picture)
    image.original_filename = "review_image.jpg"
    self.picture = image
  end

  def calculate_average_rating
    self.average_rating = ((self.content_rating.to_f + self.recomment_rating.to_f)/ 2).round(1)
  end
end