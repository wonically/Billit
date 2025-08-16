
# Billit API (Backend)

Billit API is the backend service for the Billit application, providing a secure, robust, and feature-rich RESTful API for managing invoices, expenses, clients, users, and analytics. It is built with Ruby on Rails (API-only mode) and is designed to serve as the foundation for the Billit financial management platform.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [API Endpoints](#api-endpoints-key-examples)
- [Authentication & Authorization](#authentication--authorization)
- [Database Models](#database-models)
- [Setup & Installation](#setup--installation)
- [Testing](#testing)
- [Background Jobs](#background-jobs)
- [Deployment](#deployment)
- [Development Notes](#development-notes)

---

## Overview

Billit API enables users to:

- Authenticate securely (JWT, Devise)
- Manage invoices and line items
- Track expenses with categories and receipts
- Manage client information
- Access financial analytics (KPIs, revenue, expenses, top clients, payment delays)
- Automate reminders for overdue invoices

---

## Features

- **User Authentication:** Secure login, JWT-based sessions, role-based access (admin/client)
- **Invoice Management:** CRUD, PDF export, email delivery, status tracking (draft, sent, paid, overdue)
- **Expense Tracking:** CRUD, category filtering, receipt uploads
- **Client Management:** CRUD, unique per user
- **Analytics:** Revenue over time, expense breakdown, top clients, average payment delay
- **Background Jobs:** Automated reminders for overdue invoices
- **API-First:** Clean, versionable RESTful API
- **Testing:** RSpec for request and model specs

---

## Architecture

- **Framework:** Ruby on Rails (API-only)
- **Database:** PostgreSQL
- **Authentication:** Devise, JWT
- **Background Jobs:** ActiveJob
- **PDF Generation:** WickedPDF
- **Email Delivery:** ActionMailer
- **Security:** Role-based access, parameter filtering, CORS

---

## API Endpoints (Key Examples)

- `/api/invoices` - List, create, update, delete, export, email, mark as paid
- `/api/expenses` - List, create, update, delete, filter by date/category
- `/api/clients` - List, create, update, delete
- `/analytics/monthly_revenue` - Revenue by month
- `/analytics/expense_category_breakdown` - Expenses by category
- `/analytics/top_clients` - Top clients by revenue
- `/analytics/average_payment_delay` - Average invoice payment delay

All endpoints require authentication. Admin-only actions are protected.

---

## Authentication & Authorization

- **Devise** for user management
- **JWT** for stateless API authentication
- **Roles:**
  - `admin`: Full access to all resources
  - `client`: Restricted access (view own data)
- **Authorization:** Enforced in controllers via `before_action` and custom methods

---

## Database Models

- **User:** email, password, role (admin/client), JWT support
- **Client:** name, email, address, belongs to user
- **Invoice:** belongs to user and client, has many line items, status, dates, total, note
- **LineItem:** belongs to invoice, description, quantity, unit price
- **Expense:** belongs to user, description, amount, category, date, receipt
- **JWT Denylist:** for JWT revocation

---

## Setup & Installation

1. **Clone the repository:**
 ```sh
 git clone <repo-url>
 cd billit-api
 ```

2. **Install dependencies:**
 ```sh
 bundle install
 ```

3. **Setup database:**
 ```sh
 bin/rails db:prepare
 ```

4. **Run the server:**
 ```sh
 bin/rails server
 ```

5. **Environment variables:**
 - Configure secrets in `config/credentials.yml.enc` and `config/master.key`
 - Edit `config/database.yml` as needed

---

## Testing

- **RSpec** is used for backend testing.
- To run tests:

  ```sh
  bundle exec rspec
  ```

- Tests cover models, requests, and authentication logic.

---

## Background Jobs

- Uses **ActiveJob** for background processing (e.g., sending overdue invoice reminders)
- Jobs are defined in `app/jobs/`
- Can be run with Sidekiq or the default async adapter

---

## Deployment

- **Docker:** A `Dockerfile` is provided for containerized deployment
- **Kamal:** Supported for cloud deployment
- **Environment:** Set `RAILS_ENV=production` and configure secrets

---

## Development Notes

- **API-only:** No views or assets are served; all interaction is via JSON API
- **CORS:** Configured for frontend integration
- **Security:** Parameter filtering, role checks, JWT revocation
- **Extensible:** Add new endpoints, analytics, or integrations as needed

---

## License

MIT License. See `LICENSE` file for details.
