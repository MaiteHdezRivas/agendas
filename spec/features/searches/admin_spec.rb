require 'rails_helper'

feature "Searches" do
  background do
    @user_admin = FactoryGirl.create(:user, :admin)
    signin(@user_admin.email, @user_admin.password)
  end

  describe "search events" do
    scenario 'by title, found one in singular, when original are plural', :js do
      @event = FactoryGirl.create(:event, title: 'Festividades')
      @name = Holder.where('id=?', Position.where('id=?', @event.position_id).take.holder_id).take.first_name

      @event = FactoryGirl.create(:event, title: 'Otro evento')
      @name = Holder.where('id=?', Position.where('id=?', @event.position_id).take.holder_id).take.first_name

      visit events_path
      click_link I18n.t('backend.advanced_search.title')
      fill_in 'advanced_search_title', with: 'festividad'
      click_button I18n.t("backend.advanced_search.search")
      expect(page).to have_content "Hay 1 evento"
    end

    scenario 'by date, search last month', :js do
      @event = FactoryGirl.create(:event, title: 'Festividades', scheduled: 60.days.ago)
      @name = Holder.where('id=?', Position.where('id=?', @event.position_id).take.holder_id).take.first_name

      @event = FactoryGirl.create(:event, title: 'Otro evento')
      @name = Holder.where('id=?', Position.where('id=?', @event.position_id).take.holder_id).take.first_name

      visit events_path
      click_link I18n.t('backend.advanced_search.title')
      select I18n.t("backend.advanced_search.date_3"), from: I18n.t('backend.advanced_search.date')
      click_button I18n.t("backend.advanced_search.search")
      expect(page).to have_content "Hay 1 evento"
    end

    scenario 'by date, search last month', :js do
      @event = FactoryGirl.create(:event, title: 'Festividades', scheduled: 60.days.ago)
      @name = Holder.where('id=?', Position.where('id=?', @event.position_id).take.holder_id).take.first_name

      @event = FactoryGirl.create(:event, title: 'Otro evento')
      @name = Holder.where('id=?', Position.where('id=?', @event.position_id).take.holder_id).take.first_name

      visit events_path
      click_link I18n.t('backend.advanced_search.title')
      select I18n.t("backend.advanced_search.date_3"), from: I18n.t('backend.advanced_search.date')
      click_button I18n.t("backend.advanced_search.search")
      expect(page).to have_content "Hay 1 evento"
    end
  end
end
