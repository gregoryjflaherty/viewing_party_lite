require 'rails_helper'

RSpec.describe User, type: :model do

  describe "relationships" do
    it {have_many(:party_users)}
    it {have_many(:parties).through(:party_users)}
  end

  describe "validations" do
    it { should validate_uniqueness_of(:email)}
    it { should validate_presence_of(:password_digest)}
    it { should have_secure_password}
    it "should be able to create users" do
      user = User.create(name: 'Meg', email: 'meg@test.com', password: 'password123', password_confirmation: 'password123')
      expect(user).to_not have_attribute(:password)
      expect(user.password_digest).to_not eq('password123')
    end
  end
end
