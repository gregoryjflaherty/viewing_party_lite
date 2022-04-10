require 'rails_helper'

RSpec.describe 'Login Page' do
  describe 'login form' do
    it "has fields for email and password, when filled in
    user is redirected to user dashboard page" do
      @user1 = User.create!(name: "User 1", email: 'first_email@gmail.com', password:'1', password_confirmation: '1' )
      @user2 = User.create!(name: "User 2", email: 'second_email@yahoo.com', password:'1', password_confirmation: '1' )
      visit '/login'
      #save_and_open_page
      fill_in 'Email', with:'first_email@gmail.com'
      fill_in 'Password', with: "1"
      click_on 'Login'
      expect(current_path).to eq(user_path(@user1))
    end
  end
end
