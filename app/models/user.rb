# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  user_name       :text             not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null

class User < ActiveRecord::Base


  validates :user_name, presence: true, uniqueness: true
  validates :password_digest, presence: true, uniqueness: true
  validates :session_token, presence: true, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }

  after_initialize :ensure_session_token

  attr_reader :password

#self?

  def self.reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save!
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end


  def self.find_by_credentials(username, password)
    user = User.find_by_user_name(username)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end


def ensure_session_token
  self.session_token ||= SecureRandom.urlsafe_base64
end



end
