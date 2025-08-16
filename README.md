# Billit

Billit is a full-stack web application designed to help small businesses and freelancers manage their finances, focusing on invoicing, expense tracking, and financial analytics. It provides a secure, multi-user environment for managing invoices, tracking expenses, analyzing financial performance, and interacting with clients.

---

## Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Main Features](#main-features)
- [Usage](#usage)
- [Technologies Used](#technologies-used)
- [Who Is This For?](#who-is-this-for)

---

## Project Overview

Billit enables users to:

- Create, manage, and send invoices to clients
- Track expenses with categories and receipt uploads
- Visualize financial KPIs and trends
- Manage client information
- Automate reminders for overdue invoices

---

## Architecture

Billit consists of two main components:

### 1. Backend API (`billit-api`)

- **Framework:** Ruby on Rails (API-only)
- **Key Features:**
  - Secure authentication (Devise, JWT)
  - Role-based access (admin/client)
  - Invoice and expense CRUD operations
  - Client management
  - Analytics endpoints (revenue, expenses, KPIs)
  - PDF export and email delivery for invoices
  - Background jobs for reminders
  - RSpec test suite

### 2. Frontend (`billit-frontend`)

- **Framework:** Vue 3, Vite, Tailwind CSS
- **Key Features:**
  - Dashboard with KPIs, revenue, expenses, and invoice status charts
  - Invoices and expenses management views
  - Responsive sidebar navigation
  - Authentication and route protection
  - Modern, user-friendly UI

---

## Main Features

- **User Authentication:** Secure login with JWT, admin/client roles
- **Invoice Management:** Create, edit, delete, export (PDF), and email invoices; track status (draft, sent, paid, overdue)
- **Expense Tracking:** Add, edit, delete expenses with categories and receipt uploads
- **Client Management:** Store and manage client details
- **Analytics Dashboard:** Visual KPIs, revenue trends, expense breakdown, and invoice status
- **Background Jobs:** Automated reminders for overdue invoices
- **API-First:** RESTful API for all resources
- **Testing:** Comprehensive backend test suite

---

## Usage

### Running the Project

#### Backend

```sh
cd billit-api
bundle install
bin/rails db:prepare
bin/rails server
```

#### Frontend

```sh
cd billit-frontend
npm install
npm run dev
```

### API Endpoints

- `/api/invoices` - CRUD for invoices
- `/api/expenses` - CRUD for expenses
- `/api/clients` - Manage clients
- `/analytics/*` - Financial analytics

### Dashboard

- View KPIs, revenue over time, expense split, and invoice status
- Filter and manage invoices and expenses

---

## Technologies Used

- **Backend:** Ruby on Rails, PostgreSQL, Devise, JWT, RSpec, ActiveJob
- **Frontend:** Vue 3, Vite, Tailwind CSS, Recharts
- **Other:** Docker support, background jobs, PDF generation, email delivery

---

## Who Is This For?

Billit is ideal for freelancers, consultants, and small businesses who need a simple, modern tool to manage invoices, expenses, and financial analytics in one place.
