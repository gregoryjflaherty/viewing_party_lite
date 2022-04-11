require 'rails_helper'

RSpec.describe 'Register Page' do
  describe 'has a form to fill out with name, email, password, and
  password confirmation that creates a new user' do
    it 'has a form with inputs that redirects to the created
    users show page' do
      visit root_path
      click_on 'Create a New User'
      expect(current_path).to eq(register_path)

      fill_in 'Name', with: 'Logan'
      fill_in 'Email', with: 'l@gmail.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_on 'Register'
      logan = User.find_by(name:'Logan')

      expect(current_path).to eq(dashboard_path)
    end

    it "displays an error message and redirects to register page
    if passwords don't match" do
      visit register_path

      fill_in 'Name', with: 'Conor'
      fill_in 'Email', with: 'c@gmail.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'assword'
      click_on 'Register'
      conor = User.find_by(name:'Conor')

      expect(current_path).to eq(register_path)
      expect(page).to have_content("Password confirmation doesn't match Password")
    end

    it "displays an error message and redirects to register page
    if not all fields are filled in match" do
      visit register_path

      fill_in 'Email', with: 'c@gmail.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_on 'Register'
      conor = User.find_by(name:'Conor')

      expect(current_path).to eq(register_path)
      expect(page).to have_content("Name can't be blank")
    end
  end
end
