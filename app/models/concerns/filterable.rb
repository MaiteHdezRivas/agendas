module Filterable
  extend ActiveSupport::Concern

  included do
    scope :by_holder,               -> (position)  { where(position_id: position)}
    scope :by_manage_same_holders,  -> (manage)  { where(user_id: manage) }
    scope :by_date_range,           -> (date_range) { where(scheduled: date_range) }
  end

  class_methods do

    def filter(params)
      resources = self.all
      params.each do |filter, value|
        if allowed_filter?(filter, value)
          resources = resources.send("by_#{filter}", value)
        end
      end
      resources
    end

    def allowed_filter?(filter, value)
      return if value.blank?
      ['holder', 'manage_same_holders', 'date_range'].include?(filter)
    end

  end

end