class Micropost < ApplicationRecord
  belongs_to :user
  scope :created_at_desc, ->{order created_at: :desc}
  scope :following_by, ->id {where "user_id IN (SELECT followed_id
    FROM relationships  WHERE  follower_id = user_id)
    OR user_id = user_id", user_id: id}
  mount_uploader :picture, PictureUploader
  validates :user, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

  private
  def picture_size
    if picture.size > 5.megabytes
      errors.add :picture, "should be less than 5MB"
    end
  end
end
