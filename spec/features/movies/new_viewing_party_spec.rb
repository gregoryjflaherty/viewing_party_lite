require 'rails_helper'

RSpec.describe 'new viewing party page' do
  before(:each) do
    @user = User.create!(name: 'Kat', email: 'kat@yahoo.com', password: 'test', password_confirmation: 'test')
    @user2 = User.create!(name: 'G', email: 'g@gmail.com', password: 'test1', password_confirmation: 'test1')
    @movie = @movie_2 = Movie.create!(api_id: 650)

    visit login_path
    fill_in :email, with: @user.email
    fill_in :password, with: @user.password
    click_on "Login"
  end

  describe 'new viewing party' do
    VCR.use_cassette('boyz_n_the_hood') do
      it "has a button to create new party" do
        visit user_movie_path(@user, @movie)

        within "div.button" do
          expect(page).to have_button("Create Viewing Party for Boyz n the Hood")
        end
      end

      it "takes you to a form to create new party" do
        visit user_movie_viewing_party_new_path(@user, @movie.api_id)
        expect(current_path).to eq(user_movie_viewing_party_new_path(@user, @movie.api_id))

        within "div.form" do
          expect(page).to have_content('Movie Title: Boyz n the Hood')
          expect(page).to have_content('Duration of party')
          expect(page).to have_field(:duration, with: 112)
          expect(page).to have_content('Date')
          expect(page).to have_content('Start time')
        end
      end

      it "fills in a form and creates that party" do
        visit user_movie_viewing_party_new_path(@user, @movie.api_id)
        expect(current_path).to eq(user_movie_viewing_party_new_path(@user, @movie.api_id))

        within "div.form" do
          fill_in :date, with: Date.today.strftime('%Y-%m-%d')
          fill_in :start, with: '7:00 PM'
          click_on "Create Party"

        end

        expect(current_path).to eq(users_dashboard_path)

        expect(page).to have_content("Boyz n the Hood")
        expect(page).to have_content(Date.today.strftime('%A, %B %d, %Y'))
        expect(page).to have_content("Hosting")
      end
    end
  end
end
