require 'rails_helper'

RSpec.describe 'new viewing party page' do
  before(:each) do
    User.destroy_all
    @user = User.create!(name: 'Kat', email: 'kat@yahoo.com', password:"2", password_confirmation:"2")
  end

  describe 'new viewing party' do
    VCR.use_cassette('boyz_n_the_hood') do
      it "has a button to create new party" do
        visit user_discover_index_path(@user)
        fill_in "Search", with: "boyz"
        click_on 'Find Movies'
        click_on 'Boyz n the Hood'
        within "div.button" do
          expect(page).to have_button("Create Viewing Party for Boyz n the Hood")
        end
      end

      it "takes you to a form to create new party" do
        visit user_discover_index_path(@user)
        fill_in "Search", with: "boyz"
        click_on 'Find Movies'
        click_on 'Boyz n the Hood'
        click_on "Create Viewing Party for Boyz n the Hood"

        within "div.form" do
          expect(page).to have_content('Movie Title: Boyz n the Hood')
          expect(page).to have_content('Duration of party')
          expect(page).to have_field(:duration, with: 112)
          expect(page).to have_content('Date')
          expect(page).to have_content('Start time')
        end
      end

      it "fills in a form and creates that party" do
        visit user_discover_index_path(@user)
        fill_in "Search", with: "boyz"
        click_on 'Find Movies'
        click_on 'Boyz n the Hood'
        click_on "Create Viewing Party for Boyz n the Hood"

        within "div.form" do
          fill_in :date, with: Date.today.strftime('%Y-%m-%d')
          fill_in :start, with: '7:00 PM'
          click_on "Create Party"
        end

        expect(current_path).to eq(user_path(@user))
        @date = Time.now
        expect(page).to have_content("Boyz n the Hood")
        expect(page).to have_content("#{@date.strftime("%A, %B %d, %Y")}")
        expect(page).to have_content("Hosting")
      end
    end
  end
end
