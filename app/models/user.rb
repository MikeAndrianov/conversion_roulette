class User < ApplicationRecord
  attr_accessor :login

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         authentication_keys: [:login]

  has_many :forecasts

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validate :validate_username

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)

    if login
      where(conditions.to_hash)
        .where(['lower(username) = :value OR lower(email) = :value', { value: login.downcase }])
        .first
    elsif conditions.key?(:username) || conditions.key?(:email)
      conditions[:email].downcase! if conditions[:email]
      where(conditions.to_hash).first
    end
  end

  private

  def validate_username
    errors.add(:username, :invalid) if User.find_by(email: username)
  end
end
