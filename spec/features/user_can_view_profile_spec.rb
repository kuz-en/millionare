require 'rails_helper'

RSpec.feature 'user can view profile', type: :feature do
  let(:user) { create(:user, name: 'I am Groot') }
  let(:user_with_games) { create(:user, name: 'Ender')}

  let!(:game_1) { create(:game_with_questions, user: user_with_games) }
  let!(:game_2) { create(:game_with_questions,
                               user: user_with_games,
                               current_level: 3,
                               prize: 100_500,
                               fifty_fifty_used: true,
                               created_at: Time.parse('2021.07.03, 13:00'),
                               finished_at: Time.parse('2021.07.03, 16:00')) }

  before(:each) do
    login_as user
  end

  scenario 'user is successfully looking at another profile' do
      visit '/'
      click_link 'Ender'

      expect(page).to have_current_path "/users/#{user_with_games.id}"

      expect(page).to have_content 'Ender'

      expect(page).not_to have_content 'Сменить имя и пароль'

      expect(page).to have_content 'Дата'

      # game_1
      expect(page).to have_content 'в процессе'
      expect(page).to have_content '0 ₽'

      # game_2
      expect(page).to have_content 'деньги'
      expect(page).to have_content '03 июля, 13:00'
      expect(page).to have_content '100 500 ₽'

      expect(page).to have_css('.game-help-used', text: '50/50')
  end
end
