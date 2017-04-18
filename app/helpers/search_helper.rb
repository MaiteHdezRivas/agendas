module SearchHelper

  def checked_include_participant
    params[:advanced_search].try(:[], :include_participant).present?
  end

  def holder_search_options
    options_for_select(@positions.map{|position| [position.holder.full_name_comma+' - '+position.title, position.id]},
                       params[:advanced_search].try(:[], :holder))
  end

  def manage_same_holders_search_options
    options_for_select(@manage_same_holders.map{|manage| [manage.user.full_name_comma, manage.id]},
                       params[:advanced_search].try(:[], :manage_same_holders))
  end

  def date_range_options
    options_for_select([
      [t("backend.advanced_search.date_1"), 1],
      [t("backend.advanced_search.date_2"), 2],
      [t("backend.advanced_search.date_3"), 3],
      [t("backend.advanced_search.date_4"), 4],
      [t("backend.advanced_search.date_5"), 'custom']],
      selected_date_range)
  end

  def selected_date_range
    custom_date_range? ? 'custom' : params[:advanced_search].try(:[], :date_range)
  end

  def custom_date_range?
    params[:advanced_search].try(:[], :date_max).present?
  end

end
