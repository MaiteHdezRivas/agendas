feature 'Events' do

  describe 'user manager' do

    background do
      @user_manager = FactoryGirl.create(:user, :user)
      @position = FactoryGirl.create(:position)
      @user_manager.manages.create(holder_id: @position.holder_id)
      signin(@user_manager.email, @user_manager.password)
    end

    scenario 'visit the events index page' do
      visit events_path
      expect(page).to have_content I18n.t 'backend.events'
    end

    scenario 'visit create event form' do
      visit new_event_path
      expect(page).to have_selector('#new_event')
      expect(page).not_to have_selector('#edit_event')
    end
  end

  describe 'user admin' do
    background do
      @user_admin = FactoryGirl.create(:user, :admin)
      @position = FactoryGirl.create(:position)
      @user_admin.manages.create(holder_id: @position.holder_id)
      signin(@user_admin.email, @user_admin.password)
    end

    scenario 'visit show event page' do
      event = FactoryGirl.create(:event, title: 'New event from Capybara', user: @user)
      visit events_path
      click_link event.title
      expect(page).to have_content event.title
    end

    scenario 'edit event and modify title' do
      event = FactoryGirl.create(:event, title: 'Test event', user: @user)
      visit edit_event_path(event)
      fill_in :event_title, with: 'New event modified from Capybara'
      click_button I18n.t 'backend.save'
      expect(page).to have_content 'New event modified from Capybara'
    end

    scenario 'visit search by title' do
      @event = FactoryGirl.create(:event, title: 'New event from Capybara')
      visit events_path
      fill_in :search_title, with: 'Capybara'
      click_button I18n.t('backend.search.button')
      expect(page).to have_content @event.title
    end

    scenario 'visit search by person' do
      @event = FactoryGirl.create(:event, title: 'New event from Capybara')
      @name = Holder.where('id=?', Position.where('id=?', @event.position_id).take.holder_id).take.first_name
      visit events_path
      fill_in :search_person, with: @name
      click_button I18n.t('backend.search.button')
      expect(page).to have_content @event.title
    end

    scenario 'visit non results search page' do
      @event = FactoryGirl.create(:event, title: 'New not found event')
      visit events_path
      fill_in :search_title, with: 'Capybara'
      click_button I18n.t('backend.search.button')
      expect(page).not_to have_content @event.title
    end
 end
end
