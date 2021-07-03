require 'rails_helper'

RSpec.feature 'user can view profile', type: :feature do
  let(:user) { FactoryGirl.create(:user, name: 'I am groot') }

  let!(:game_1) { FactoryGirl.create(:game_with_questions, user: user) }

  let!(:game_2) { FactoryGirl.create(:game_with_questions,
                                     user: user,
                                     current_level: 3,
                                     prize: 100_500,
                                     fifty_fifty_used: true,
                                     created_at: Time.parse('2021.07.03, 13:00'),
                                     finished_at: Time.parse('2021.07.03, 16:00')) }
  scenario 'anonymous user' do
      visit '/'
      click_link 'I am groot'

      expect(page).to have_current_path "/users/#{user.id}"

      expect(page).to have_content 'I am groot'
      expect(page).to have_content 'Войти'

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
