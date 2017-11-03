feature 'Event page' do

  #Creamos muchos holders para que salgan todos en el listado
  before(:each) do
    load "#{Rails.root}/db/search_seeds.rb"
  end

  background do
    @user_admin = FactoryGirl.create(:user, :admin)
    signin(@user_admin.email, @user_admin.password)
    @name = Holder.where('id=?', Position.where('id=?', @event.position_id).take.holder_id).take.first_name
    @name = Holder.where('id=?', Position.where('id=?', @event.position_id).take.holder_id).take.first_name
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

  feature 'XXX' do
    before(:each) do
    end

    scenario 'XXX' do
    end
  end

end
