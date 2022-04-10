require 'rails_helper'

RSpec.describe PartyUser, type: :model do

  describe "relationships" do
    it {belong_to(:user)}
    it {belong_to(:party)}
  end
end
