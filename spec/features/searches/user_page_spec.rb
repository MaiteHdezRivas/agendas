feature 'Event page' do

  #Creamos muchos holders para que sólo salgan los que maneja el user
  before(:each) do
    load "#{Rails.root}/db/search_seeds.rb"
  end

  background do
    #@user_without_holders = User.find_by first_name: 'Pepe', last_name: 'Perez'

    @user_with_holders = User.find_by first_name: 'Catalina', last_name: 'Perez'
    signin(@user_with_holders.email, @user_with_holders.password)
  end

  scenario 'visit the event page' do
    visit events_path
    expect(page).to have_content I18n.t('backend.advanced_search.title')
  end

  scenario 'show advanced search', :js do
    visit events_path
    expect(page).to_not have_content I18n.t('backend.advanced_search.general')
    click_link I18n.t('backend.advanced_search.title')
    expect(page).to have_content I18n.t('backend.advanced_search.general')
  end

  scenario 'only managed holders at select options', :js do
    visit events_path
    select I18n.t("backend.advanced_search.date_3"), from: I18n.t('backend.advanced_search.date')
    click_link "advanced_search_position"
    expect(page).to have_content I18n.t('backend.advanced_search.general')
  end

  scenario 'only managed holders at select options', :js do
    visit events_path
    select I18n.t("backend.advanced_search.date_3"), from: I18n.t('backend.advanced_search.manages')
    click_link "advanced_search_position"
    expect(page).to have_content I18n.t('backend.advanced_search.general')
  end






  feature 'XXX' do
    before(:each) do
    end

    scenario 'XXX' do
    end
  end

end
