class ReportsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_admin

  def index
    @date = params[:date]
    if @date
      @orders = Order.find_all_by_served_on(@date)
      @menu_items = DayOfWeek.menu_items_for_date(@date)
    end
  end
end