class User < ActiveRecord::Base
    before_save { self.email = email.downcase }
    before_create :create_activation_digest
    
    
    validates :name, presence: true, length: {maximum: 99}
    VALID_EMAIL_REGEXP = /\A[\w+\-.]+@[a-z\d.\-]+\.[a-z]+\Z/i
    validates :email, presence: true, length: {maximum: 254}, format: { with: VALID_EMAIL_REGEXP }, uniqueness: {case_sensitive: false}
    validates :password, length: {minimum: 6}, allow_blank: true
    has_secure_password
    
    
    attr_accessor :remember_token
    attr_accessor :activation_token, :reset_token
    
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
    
    def authenticated?(token, attribute = :remember) #if you do it this way, with a default value, you don't break existing code
        digest = self.send("#{attribute}_digest")
        if digest
            BCrypt::Password.new(digest).is_password?(token)
        end
    end
    
    def activate
        update_attribute(:activated, true)
        update_attribute(:activated_at, Time.zone.now)
    end
    
    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end
    
    def create_reset_token
        self.reset_token = User.new_token
        digest = User.digest(token)
        update_attribute(reset_digest: digest)
        update_attribute(reset_at: Time.zone.now)
    end
    
    def send_reset_email
        UserMailer.reset_password(self).deliver_now
    end
    
    private
    
        def create_activation_digest
            self.activation_token = User.new_token
            self.activation_digest =  User.digest(activation_token)
        end
    
end
