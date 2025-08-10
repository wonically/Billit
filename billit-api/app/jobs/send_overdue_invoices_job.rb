class SendOverdueInvoicesJob < ApplicationJob
  queue_as :default

  def perform(user)
    invoices = Invoice.where(user_id: user.id)
                      .where.not(payment_status: 'paid')
                      .where('due_date < ?', Date.today)
    invoices.find_each do |invoice|
      OverdueInvoiceMailer.reminder(invoice).deliver_later
    end
  end
end
