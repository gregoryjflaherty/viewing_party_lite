require 'rails_helper'

RSpec.describe 'Register Page' do
  describe 'has a form to fill out with name, and email that creates a new user' do
    xit 'has a form with name and email inputs that redirects to the created
    users show page' do
      visit root_path
      click_on 'Create a New User'
      expect(current_path).to eq(register_path)

      fill_in 'Name', with: 'Logan'
      fill_in 'Email', with: 'l@gmail.com'

      fill_in 'Password', with: 'Test'
      fill_in 'Password confirmation', with: 'Test'
      click_on 'Register'
      logan = User.find_by(name:'Logan')

      expect(current_path).to eq(user_path(logan))
    end

    context 'tells what I did wrong when I dont register correctly' do
      it 'forces me to put a name' do
        visit root_path
        click_on 'Create a New User'
        expect(current_path).to eq(register_path)

        fill_in 'Email', with: 'l@gmail.com'
        fill_in 'Password', with: 'Test'
        fill_in 'Password confirmation', with: 'Test'
        click_on 'Register'

        expect(page).to have_content("Name can't be blank")
        expect(current_path).to eq(register_path)
      end

      xit 'forces me to put a unique email' do
        g = User.create!(name: 'G', email: 'g@gmail.com', password: 'test', password_confirmation: 'test')
        visit root_path
        click_on 'Create a New User'
        expect(current_path).to eq(register_path)

        fill_in 'Name', with: 'Greg'
        fill_in 'Email', with: 'g@gmail.com'
        fill_in 'Password', with: 'Test'
        fill_in 'Password confirmation', with: 'Test'
        click_on 'Register'

        expect(current_path).to eq(register_path)
        expect(page).to have_content("Email has already been taken")
      end

      xit 'forces me to put matching passwords' do
        visit root_path
        click_on 'Create a New User'
        expect(current_path).to eq(register_path)

        fill_in 'Name', with: 'Greg'
        fill_in 'Email', with: 'g@gmail.com'
        fill_in 'Password', with: 'Test'
        fill_in 'Password confirmation', with: 'Best'
        click_on 'Register'

        expect(current_path).to eq(register_path)
        expect(page).to have_content("Password error")
      end
    end
  end
end
