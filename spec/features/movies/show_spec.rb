require 'rails_helper'

RSpec.describe 'Movie Details Page' do
  describe 'has users name, discover movie button and viewing party list' do
    describe 'has buttons' do
      before(:each) do
        User.destroy_all
        @user = User.create!(name: 'Kat', email: 'kat@yahoo.com', password:"2", password_confirmation:"2")
        visit login_path(@user)
        fill_in "Email", with:"#{@user.email}"
        fill_in "Password", with:"#{@user.password}"
        click_on "Login"
        visit users_discover_index_path
        fill_in "Search", with: "fight club"
        click_on 'Find Movies'
        click_on 'Fight Club'
      end

      VCR.use_cassette('fight_club_api') do
        it 'has button to create a viewing party' do
          expect(page).to have_button("Create Viewing Party for Fight Club")
        end

        it 'has button to return to discover page' do
          within "div.button" do
            expect(page).to have_button("Discover Page")
            click_on "Discover Page"
            expect(current_path).to eq(users_discover_index_path)
          end
        end

        it 'shows vote average, run time, and genre(s)' do
          within "div.attributes" do
            expect(page).to have_content("Vote Average: 8.4")
            expect(page).to have_content("Runtime: 2hr 19 min")
            expect(page).to have_content("Genre(s): Drama")
          end
        end

        it 'shows summary of movie' do
          within "div.summary" do
            expect(page).to have_content("Summary")
            expect(page).to have_content("A ticking-time-bomb")
          end
        end
      end
    end
  end
end
