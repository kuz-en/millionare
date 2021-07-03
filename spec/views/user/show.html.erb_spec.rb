require 'rails_helper'

RSpec.describe 'users/show', type: :view do
  let(:user) { FactoryBot.create :user }

  context 'as user' do
    before(:each) do
      sign_in user
      assign(:user, user)

      render
    end

    it 'renders user name' do
      expect(rendered).to match "#{user.name}"
    end

    it 'renders change password link' do
      expect(rendered).to match 'Сменить имя и пароль'
    end

    it 'renders game partial' do
      assign(:games, [FactoryBot.build_stubbed(:game)])
      stub_template 'users/_game.html.erb' => 'User game goes here'

      render

      expect(rendered).to match 'User game goes here'
    end
  end

  context 'as anon' do
    before(:each) do
      assign(:user, user)

      render
    end

    it 'renders user name' do
      expect(rendered).to match "#{user.name}"
    end

    it 'does not render link to change password' do
      expect(rendered).not_to match 'Сменить имя и пароль'
    end

    it 'renders game partial' do
      assign(:games, [FactoryBot.build_stubbed(:game)])
      stub_template 'users/_game.html.erb' => 'User game goes here'

      render

      expect(rendered).to match 'User game goes here'
    end
  end
end
