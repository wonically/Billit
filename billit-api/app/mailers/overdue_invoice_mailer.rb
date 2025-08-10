class OverdueInvoiceMailer < ApplicationMailer
  def reminder(invoice)
    @invoice = invoice
    mail(
      to: invoice.client.email,
      subject: "Invoice ##{invoice.id} is overdue"
    )
  end
end
