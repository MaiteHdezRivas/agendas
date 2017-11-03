require 'rails_helper'

feature "Searches" do
  background do
    @user_manager = FactoryGirl.create(:user)
    signin(@user_manager.email, @user_manager.password)
  end

=begin

    before(:each) do
      load "#{Rails.root}/db/search_seeds.rb"
    end

    background do
      @user_without_holders = User.find_by first_name: 'Pepe', last_name: 'Perez'

      @user_with_holders = User.find_by first_name: 'Catalina', last_name: 'Perez'
      @registration_offices = Event.find_by title: 'Oficinas de registro'
      @online_registration = Event.find_by title: 'Registro Electrónico'
      @political_transparency = Event.find_by title: 'Transparencia política'

      @holder_several_positions = Holder.find_by first_name: 'Pilar', last_name:'Lopez'

    end
=end


  describe "search events" do
    scenario 'found one in singular, when original are plural', :js do
      @event = FactoryGirl.create(:event, title: 'Festividades')
      @name = Holder.where('id=?', Position.where('id=?', @event.position_id).take.holder_id).take.first_name

      @event = FactoryGirl.create(:event, title: 'Otro evento')
      @name = Holder.where('id=?', Position.where('id=?', @event.position_id).take.holder_id).take.first_name


      visit events_path
      expect(page).to_not have_content I18n.t('backend.advanced_search.general')
      click_link I18n.t('backend.advanced_search.title')
      expect(page).to have_content I18n.t('backend.advanced_search.general')
      fill_in 'advanced_search_title', with: 'festividad'
      click_button I18n.t("backend.advanced_search.search")

      expect(page).to have_content "Hay 1 evento"

      save_and_open_page
    end
  end
end
