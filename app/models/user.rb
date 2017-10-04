class User < ApplicationRecord
  attr_accessor :login

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         authentication_keys: [:login]

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validate :validate_username

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)

    if login
      find_user_by_login
    elsif conditions.key?(:username) || conditions.key?(:email)
      find_user_by_username_or_email
    end
  end

  private

  def validate_username
    errors.add(:username, :invalid) if User.where(email: username).exists?
  end

  def find_user_by_login
    where(conditions.to_hash)
      .where(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }])
      .first
  end

  def find_user_by_username_or_email
    conditions[:email].downcase! if conditions[:email]
    where(conditions.to_hash).first
  end
end
