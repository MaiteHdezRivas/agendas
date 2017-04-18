class EventsController < AdminController
  load_and_authorize_resource
  before_action :set_holders, only: [:new, :edit, :create, :index]
  before_action :set_manages_same_holders, only: [:index]
  before_action :parse_advanced_search_terms, only: :index

  def index
    @events = current_user.admin? ? list_admin_events : list_user_events
  end

  def list_admin_events
    @events = Event.searches(params)
    @events.order(scheduled: :desc).page(params[:page]).per(50)
  end

  def list_user_events
    @events = Event.by_manages(current_user.id)

    @events = @events.p_search(params[:advanced_search][:title]) if params[:advanced_search].present? && params[:advanced_search][:title].present?

    @events = @advanced_search_terms.present? ? @events.filter(@advanced_search_terms) : @events

    @events.order(scheduled: :desc).page(params[:page]).per(50)
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    if @event.save
      redirect_to events_path, notice: t('backend.successfully_created_record')
    else
      flash[:alert] = t('backend.review_errors')
      render :new
    end
  end

  def update
    @event.user = current_user
    if @event.update_attributes(event_params)
      redirect_to events_path, notice: t('backend.successfully_updated_record')
    else
      set_holders
      flash[:alert] = t('backend.review_errors')
      render :edit
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: t('backend.successfully_destroyed_record')
  end

  def get_title
    Event.find(params[:id]).title if params[:action].present? && params[:action] == 'destroy'
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :location, :scheduled, :position_id, :search_title, :search_person, attendees_attributes: [:id, :name, :position, :company, :_destroy], participants_attributes: [:id, :position_id, :_destroy], attachments_attributes: [:id, :title, :file, :_destroy])
  end

  def set_holders
    @participants = Position.current
    @holders = current_user.admin? ? @participants : current_user.holders
    @positions = current_user.admin? ? @participants : Position.current.holders(current_user.id)
  end

  def set_manages_same_holders
    @manage_same_holders = current_user.admin? ? Manage.all : Manage.set_manages_same_holders(current_user.id)
  end

 # def parse_search_terms
 #   @search_terms = params[:search] if params[:search].present?
 # end

  def parse_advanced_search_terms
    @advanced_search_terms = params[:advanced_search] if params[:advanced_search].present?
    parse_search_date
  end

  def parse_search_date
    return unless search_by_date?
    params[:advanced_search][:date_range] = search_date_range
  end

  def search_by_date?
    params[:advanced_search] && params[:advanced_search][:date_min].present?
  end

  def search_start_date
    case params[:advanced_search][:date_min]
      when '1'
        24.hours.ago
      when '2'
        1.week.ago
      when '3'
        1.month.ago
      when '4'
        1.year.ago
      else
        Date.parse(params[:advanced_search][:date_min]) rescue 100.years.ago
    end
  end

  def search_finish_date
    (params[:advanced_search][:date_max].to_date rescue Date.today) || Date.today
  end

  def search_date_range
    [100.years.ago, search_start_date].max.beginning_of_day..[search_finish_date, Date.today].min.end_of_day
  end
end
