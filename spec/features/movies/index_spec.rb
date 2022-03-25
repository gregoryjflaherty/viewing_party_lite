require 'spec_helper'

RSpec.describe 'movie results page' do
  before(:each) do
    @user = User.create!(name: 'Trevor', email: 'trev@yahoo.com')
    @user2 = User.create!(name: 'Kat', email: 'kat@yahoo.com')
  end

  it "has links to movies in search results" do
    visit user_discover_index_path(@user)
    VCR.use_cassette('fight_results_api') do
      fill_in "Search", with: "fight"
      click_on 'Find Movies'
      expect(page).to have_content('Fight Club')
      expect(page).to_not have_content('Godfather')
      expect(page).to have_content('Vote Average: 5')
      expect(page).to_not have_content('Vote Average: 8')
    end
  end
end
