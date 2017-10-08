require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:forecasts) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }

    it 'refuses to take username if such email is already created' do
      user = build(:user, username: 'my@mail.com')

      expect(user).to be_valid

      create(:user, email: 'my@mail.com')

      expect(user).to_not be_valid
    end
  end
end
