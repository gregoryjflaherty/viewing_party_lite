require 'rails_helper'

RSpec.describe 'User Dashboard' do
  describe 'has users name, discover movie button and viewing party list' do
    before(:each) do
      @jax = User.create!(name: "Jackson", email: "j@jmail.com")

      @movie_1 = Movie.create!(api_id: 550)
      @movie_2 = Movie.create!(api_id: 600)


      @party_1 = Party.create!(movie_id: @movie_1.id, duration: 126, date: "3/22/22", start: '7:00 pm')
      @party_2 = Party.create!(movie_id: @movie_2.id, duration: 108, date: "3/23/22", start: '8:00 pm')

      @party_user_1 = PartyUser.create!(is_host: true, party_id: @party_1.id, user_id: @jax.id)
      @party_user_2 = PartyUser.create!(is_host: false, party_id: @party_2.id, user_id: @jax.id)
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

    it 'lists viewing parties' do
      visit user_path(@jax)
      expect(current_path).to eq(user_path(@jax))
      save_and_open_page
      expect(page).to have_content("Viewing Parties")

      VCR.use_cassette('fight_club_api') do
        within "div.parties-#{@party_user_1.id}" do
          expect(page).to have_content("Fight Club")
          expect(page).to have_content("March 22, 2022")
          expect(page).to have_content("Hosting")
        end
      end

      # within "div.parties-#{@party_user_1.id}" do
      #   expect(page).to have_content("Full Metal Jacket")
      #   expect(page).to have_content("March 23, 2022")
      #   expect(page).to have_content("Invited")
      # end
    end
  end
end