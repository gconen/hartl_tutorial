class Micropost < ActiveRecord::Base
    belongs_to :user
    
    mount_uploader :picture, PictureUploader
    
    validates :user_id, presence: true
    validates :content, presence: true, length: {maximum: 140}
    validate :picture_size #validate not validates; validates fails in arcane, opaque ways that makes it hard to track down the source of the problem.
    
    default_scope -> {order(created_at: :desc)}
    
    
    def picture_size
        if picture.size > 5.megabytes
            errors.add(:picture, "should be less than 5MB")
        end
    end

end
