class AnalyticsController < ApplicationController
  before_action :authenticate_user!

  def monthly_revenue
    data = AnalyticsService.monthly_revenue(current_user)
    render json: data
  end

  def top_clients
    data = AnalyticsService.top_clients(current_user)
    render json: data
  end

  def average_payment_delay
    data = AnalyticsService.average_payment_delay(current_user)
    render json: { average_payment_delay: data }
  end

  def expense_category_breakdown
    data = AnalyticsService.expense_category_breakdown(current_user)
    render json: data
  end
end
