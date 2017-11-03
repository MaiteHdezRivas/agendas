App.AdvancedSearch = {
    advanced_search_terms: function() {
        return $('#js-advanced-search').data('advanced-search-terms');
    },
    toggle_form: function(event) {
        event.preventDefault();
        return $('#js-advanced-search').slideToggle();
    },
    toggle_date_options: function() {
        if ($('#js-advanced-search-date-min').val() === 'custom') {
            $('#js-custom-date').show();
        } else {
            $('#advanced_search_date_min').removeAttr('value');
            $('#advanced_search_date_max').removeAttr('value');
            $('#js-custom-date').hide();
        }
    },
    init_calendar: function() {
        $('.fdatepicker').fdatepicker({
            format: "dd/mm/yyyy",
            pickTime: false,
            language: "es",
            disableDblClickSelection: true,
            weekStart: 1
        });
    },

    initialize: function() {
        App.AdvancedSearch.init_calendar();

        if (App.AdvancedSearch.advanced_search_terms()) {
            $('#js-advanced-search').show();
            App.AdvancedSearch.toggle_date_options();
        }
        $('#js-advanced-search-title').on({
            click: function(event) {
                return App.AdvancedSearch.toggle_form(event);
            }
        });
        return $('#js-advanced-search-date-min').on({
            change: function() {
                return App.AdvancedSearch.toggle_date_options();
            }
        });
    }
};