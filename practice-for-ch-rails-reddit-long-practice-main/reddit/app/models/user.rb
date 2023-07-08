# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  session_token   :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    before_validation :ensure_session_token
    validates :username, :session_token, :password_digest, presence: true
    validates :username, :session_token, uniqueness: true
    validates :password, length: {minimum: 6, allow_nil: true}
    attr_reader :password

    has_many :subs,
        foreign_key: :moderator_id,
        class_name: :Sub,
        dependent: :destroy

    def password=(password)
        @password = password
        self.password_digest = BCrypt::Password.create(password)
    end

    def self.find_by_credentials(username, password)
        user = User.find_by(username: username)
        if user && user.is_password?(password)
            user
        else
            nil
        end
    end

    def is_password?(password)
        b_obj = BCrypt::Password.new(self.password_digest)
        b_obj.is_password?(password)
    end

    def reset_session_token!
        self.session_token = generate_unique_session_token
        self.save
        self.session_token
    end

    private
    def generate_unique_session_token
        token = SecureRandom::urlsafe_base64
        token = SecureRandom::urlsafe_base64 while User.exists?(session_token: token)
        token
    end

    def ensure_session_token
        self.session_token ||= generate_unique_session_token
    end
end
