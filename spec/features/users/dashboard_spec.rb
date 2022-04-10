require 'rails_helper'

RSpec.describe 'User Dashboard' do
  describe 'has users name, discover movie button and viewing party list' do
    before(:each) do
      User.destroy_all
      @jax = User.create!(name: "Jackson", email: "j@jmail.com", password: "J", password_confirmation: "J")
      @date = Time.now
    end

    it 'has users name' do
      visit user_path(@jax)
      expect(current_path).to eq(user_path(@jax))

      within "div.name" do
        expect(page).to have_content("#{@jax.name}'s Dashboard")
      end
    end

    it 'has discover movie button' do
      visit user_path(@jax)
      expect(current_path).to eq(user_path(@jax))

      within "div.discover_button" do
        expect(page).to have_button("Discover Movies")
        click_on "Discover Movies"
        expect(current_path).to eq(user_discover_index_path(@jax))
      end
    end
    VCR.use_cassette('top_20_api') do
      it 'lists viewing parties' do
        visit user_discover_index_path(@jax)
        fill_in "Search", with: "shaw"
        click_on 'Find Movies'
        click_on 'The Shawshank Redemption'
        click_on "Create Viewing Party for The Shawshank Redemption"

        within "div.form" do
          fill_in :date, with: Date.today.strftime('%Y-%m-%d')
          fill_in :start, with: '7:00 PM'
          click_on "Create Party"
        end

        #@user = User.create!(name: 'Kat', email: 'kat@yahoo.com', password:"2", password_confirmation:"2")
        visit user_discover_index_path(@jax)
        fill_in "Search", with: "gab"
        click_on 'Find Movies'
        click_on "Gabriel's Inferno"
        click_on "Create Viewing Party for Gabriel's Inferno"

        within "div.form" do
          fill_in :date, with: Date.today.strftime('%Y-%m-%d')
          fill_in :start, with: '10:00 PM'
          #check "Jackson (j@jmail.com)"
          click_on "Create Party"
        end

        visit user_path(@jax)
        expect(page).to have_content("Viewing Parties")

        # within "div.parties-1" do
        #   expect(page).to have_content("The Shawshank Redemption")
        #   expect(page).to have_content("#{@date.strftime("%A, %B %d, %Y")}")
        #   expect(page).to have_content("07:00 pm")
        #   expect(page).to have_content("Hosting")
        # end

        within "div.parties-1" do
          expect(page).to have_content("Gabriel's Inferno")
          expect(page).to have_content("#{@date.strftime("%A, %B %d, %Y")}")
          expect(page).to have_content("10:00 pm")
          # expect(page).to have_content("Invited")
          expect(page).to have_content("Hosting")
        end
      end
    end
  end
end
