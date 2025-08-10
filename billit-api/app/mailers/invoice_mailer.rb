class InvoiceMailer < ApplicationMailer
  def send_invoice(invoice, recipient_email)
    @invoice = invoice
    attachments["invoice-#{invoice.id}.pdf"] = WickedPdf.new.pdf_from_string(
      render_to_string(template: 'invoices/pdf.html.erb', locals: { invoice: invoice })
    )
    mail(
      to: recipient_email,
      subject: "Invoice ##{invoice.id}",
      body: "Invoice ##{invoice.id} for #{invoice.client.name}.\nTotal: #{invoice.total}\nDue: #{invoice.due_date}"
    )
  end
end
