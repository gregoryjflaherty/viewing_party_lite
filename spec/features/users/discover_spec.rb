require 'rails_helper'

RSpec.describe 'Discover Page' do
  describe 'happy path' do
    before(:each) do
      User.destroy_all
      @user = User.create!(name: 'Kat', email: 'kat@yahoo.com', password:"2", password_confirmation:"2")
      visit login_path(@user)
      fill_in "Email", with:"#{@user.email}"
      fill_in "Password", with:"#{@user.password}"
      click_on "Login"
    end

    it 'should have a button to discover top 20 rated movies' do
      visit users_discover_index_path
      VCR.use_cassette('top_20_api') do
        click_on 'Find Top Rated Movies'
        expect(current_path).to eq(users_movies_path)
      end
    end

    it 'has a search bar to find up to 40 movies' do
      visit users_discover_index_path
      VCR.use_cassette('fight_results_api') do
        fill_in 'Search', with:'fight'
        click_on 'Find Movies'

        expect(current_path).to eq(users_movies_path)
      end
    end
  end
end
