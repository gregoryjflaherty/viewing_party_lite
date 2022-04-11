require 'rails_helper'

RSpec.describe 'movie results page' do
  before(:each) do
    User.destroy_all
    @user = User.create!(name: 'Kat', email: 'kat@yahoo.com', password:"2", password_confirmation:"2")
    visit login_path(@user)
    fill_in "Email", with:"#{@user.email}"
    fill_in "Password", with:"#{@user.password}"
    click_on "Login"
  end
  it "has different title depending on search" do
    visit users_discover_index_path
    VCR.use_cassette('fight_results_api') do
      fill_in "Search", with: "fight"
      click_on 'Find Movies'

      expect(page).to have_content("Movie Results for: fight")
      expect(page).to_not have_content("Top Rated Movies")
    end
    visit users_discover_index_path
    VCR.use_cassette('top_20_api') do
      click_on 'Find Top Rated Movies'

      expect(page).to_not have_content("Movie results for: fight")
      expect(page).to have_content("Top Rated Movies")
    end
  end

  it "has a button that links to the discover movies index" do
    visit users_discover_index_path
    VCR.use_cassette('top_20_api') do
      click_on 'Find Top Rated Movies'
      click_on 'Discover Page'
      expect(current_path).to eq(users_discover_index_path)
    end
  end

  it "lists the top rated movies" do
    visit users_discover_index_path
    VCR.use_cassette('top_20_api') do
      click_on 'Find Top Rated Movies'

      expect(page).to have_content('The Shawshank Redemption')
      expect(page).to have_content('Vote Average: 8.7')
    end
  end

  it "has links to movies in search results and vote averages" do
    visit users_discover_index_path
    VCR.use_cassette('fight_results_api') do
      fill_in "Search", with: "fight"
      click_on 'Find Movies'

      expect(page).to have_content('Fight Club')
      expect(page).to_not have_content('Godfather')
      expect(page).to have_content('Vote Average: 8.4')
    end
  end
end
