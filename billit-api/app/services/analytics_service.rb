class AnalyticsService
  def self.monthly_revenue(user)
    query = <<-SQL
      WITH paid_invoices AS (
        SELECT
          invoices.id,
          invoices.total,
          date_trunc('month', invoices.invoice_date) AS month
        FROM invoices
        WHERE invoices.payment_status = 'paid'
          AND invoices.user_id = :user_id
      )
      SELECT
        to_char(month, 'YYYY-MM') AS month,
        SUM(total) AS revenue
      FROM paid_invoices
      GROUP BY month
      ORDER BY month
    SQL

    result = ActiveRecord::Base.connection.exec_query(
      query,
      'SQL',
      [{ name: 'user_id', value: user.id }]
    )

    result.map { |row| { month: row['month'], revenue: row['revenue'].to_f } }
  end

  def self.top_clients(user)
    query = <<-SQL
      WITH paid_invoices AS (
        SELECT
          invoices.client_id,
          invoices.total
        FROM invoices
        WHERE invoices.payment_status = 'paid'
          AND invoices.user_id = :user_id
      )
      SELECT
        clients.name AS client_name,
        SUM(paid_invoices.total) AS total
      FROM paid_invoices
      JOIN clients ON clients.id = paid_invoices.client_id
      GROUP BY clients.name
      ORDER BY total DESC
      LIMIT 5
    SQL

    result = ActiveRecord::Base.connection.exec_query(
      query,
      'SQL',
      [{ name: 'user_id', value: user.id }]
    )

    result.map { |row| { client_name: row['client_name'], total: row['total'].to_f } }
  end

  def self.average_payment_delay(user)
    query = <<-SQL
      SELECT AVG(payment_date - invoice_date) AS avg_days
      FROM invoices
      WHERE payment_status = 'paid'
        AND user_id = :user_id
        AND payment_date IS NOT NULL
        AND invoice_date IS NOT NULL
    SQL

    result = ActiveRecord::Base.connection.exec_query(
      query,
      'SQL',
      [{ name: 'user_id', value: user.id }]
    )

    result.first['avg_days'].to_f
  end

  def self.expense_category_breakdown(user)
    query = <<-SQL
      SELECT category, SUM(amount) AS total
      FROM expenses
      WHERE user_id = :user_id
      GROUP BY category
      ORDER BY total DESC
    SQL

    result = ActiveRecord::Base.connection.exec_query(
      query,
      'SQL',
      [{ name: 'user_id', value: user.id }]
    )

    result.map { |row| { category: row['category'], total: row['total'].to_f } }
  end
end
