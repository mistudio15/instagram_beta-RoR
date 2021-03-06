class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  has_many :likes, dependent: :destroy
  # has_many :users, through: :likes

  has_one_attached :photo

  validates :title, presence: true
end
