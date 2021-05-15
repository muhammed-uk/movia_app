module Play
  class QueryScope
    def initialize(initial_scope)
      @scoped_result = initial_scope
    end

    def call(query_params)
      scoped = @scoped_result
      scoped = filter_by_date(scoped, query_params[:date]) if query_params[:date].present?
      scoped = filter_by_timeslot(scoped, query_params[:timeslot]) if query_params[:timeslot].present?
      scoped = filter_by_user_id(scoped, query_params[:user_id]) if query_params[:user_id].present?
      scoped = filter_by_show_id(scoped, query_params[:show_id]) if query_params[:show_id].present?
      scoped
    end

    private

    def filter_by_date(scoped, date)
      return unless date.respond_to?(:to_date)

      scoped.where(date: date.to_date)
    end

    # def filter_by_timeslot(scoped, slot)
    #   scoped.where(timeslot: slot)
    # end
    #
    # def filter_by_user_id(scoped, user_id)
    #   scoped.where(user_id: user_id)
    # end
    #
    # def filter_by_show_id(scoped, show_id)
    #   scoped.where(show_id: show_id)
    # end

    %w[show_id user_id timeslot].each do |method|
      define_method "filter_by_#{method}" do |scoped, filter_param|
        scoped.where(method => filter_param)
      end
    end
  end
end