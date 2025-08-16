
# Billit Frontend

Billit Frontend is the user interface for the Billit application, providing a modern, responsive, and user-friendly experience for managing invoices, expenses, clients, and financial analytics. Built with Vue 3, Vite, and Tailwind CSS, it consumes the Billit API backend and visualizes business data for end users.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Setup & Installation](#setup--installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Development Notes](#development-notes)

---

## Overview

Billit Frontend enables users to:

- Log in securely and manage their session
- View dashboards with KPIs, revenue, expenses, and invoice status
- Create, edit, and manage invoices and expenses
- Filter and analyze financial data visually
- Navigate easily with a responsive sidebar and modern UI

---

## Features

- **Authentication:** JWT-based login, route protection
- **Dashboard:** KPIs, revenue trends, expense breakdown, invoice status (charts)
- **Invoices:** List, filter, edit, and delete invoices
- **Expenses:** List, filter (by date/category), edit, and delete expenses
- **Navigation:** Responsive sidebar, mobile-friendly design
- **Modern UI:** Built with Tailwind CSS and Headless UI
- **API Integration:** Communicates with Billit API backend

---

## Setup & Installation

1. **Install dependencies:**

 ```sh
 npm install
 ```

2. **Start the development server:**

 ```sh
 npm run dev
 ```

3. **Configure API URL:**

- Edit API endpoints in `src/services/` or use environment variables as needed

---

## Usage

- Visit `http://localhost:5173` (or as shown in terminal)
- Log in with your credentials
- Use the sidebar to navigate between Dashboard, Invoices, Expenses, Analytics, and Settings
- Create, edit, and delete invoices and expenses
- View analytics and KPIs on the dashboard

---

## Project Structure

- `src/`
  - `components/` - Reusable UI components (Sidebar, ThemeToggle, etc.)
  - `views/` - Main pages (Dashboard, InvoicesView, ExpensesView, etc.)
  - `router/` - Vue Router configuration
  - `services/` - API service functions
  - `assets/` - Static assets

---

## Development Notes

- **Framework:** Vue 3, Vite, Tailwind CSS
- **Charts:** Recharts for data visualization
- **UI:** Headless UI for accessible components
- **Auth:** JWT token stored in localStorage
- **API:** Expects Billit API backend running at configured URL
- **Customization:** Easily extend views, add new features, or update styles

---

## License

MIT License. See `LICENSE` file for details.
