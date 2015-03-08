class User < ActiveRecord::Base
    before_save { self.email = email.downcase }
    validates :name, presence: true, length: {maximum: 99}
    VALID_EMAIL_REGEXP = /\A[\w+\-.]+@[a-z\d.\-]+\.[a-z]+\Z/i
    validates :email, presence: true, length: {maximum: 254}, format: { with: VALID_EMAIL_REGEXP }, uniqueness: {case_sensitive: false}
    validates :password, length: {minimum: 6}
    has_secure_password
    
    
    attr_accessor :remember_token
    
    def User.digest(password)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
        BCrypt::Password.create(password, cost: cost)
    end
    
    def User.new_token
        SecureRandom.urlsafe_base64
    end
    
    def remember
        self.remember_token = User.new_token

        update_attribute(:remember_digest, User.digest(remember_token))
    end
    
    def forget
        update_attribute(:remember_digest, nil)
    end
    
    def authenticated?(remember_token)
        if remember_digest
            BCrypt::Password.new(remember_digest).is_password?(remember_token)
        end
    end
    
end
