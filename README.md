# Rails Jobs Technical Test

A Rails application boilerplate for technical testing, featuring a job board with companies and job listings.
This is a Vibe coded app... yeah it's the future of our job to untangle the mess of vibe coding 🤣

## 🚀 Tech Stack

This application is built with modern Rails 8 and includes:

- **Backend**: Ruby on Rails 8.0.2
- **Database**: PostgreSQL
- **Frontend**: 
  - Tailwind CSS for styling
  - Stimulus for JavaScript interactions
  - Turbo for SPA-like navigation
- **Testing**: RSpec with FactoryBot
- **Asset Pipeline**: Propshaft
- **Background Jobs**: Solid Queue
- **Caching**: Solid Cache
- **Real-time**: Solid Cable
- **File Storage**: Active Storage
- **Rich Text**: Action Text

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Ruby 3.4+** (check with `ruby --version`)
- **PostgreSQL** (check with `psql --version`)

## ⚙️ Setup

### 1) Fork this repository
Click **Fork** on GitHub to create your own copy of the repo under your account.

### 2) Clone your fork locally
```bash
git clone https://github.com/<your-username>/technical_test_boilerplate.git
cd technical_test_boilerplate

# Optional (recommended): add the original repo as upstream
git remote add upstream https://github.com/RubyOnRailsJobs/technical_test_boilerplate.git
```

### 3) Install dependencies
```bash
bundle install
```

### 4) Database setup
```bash
# Create the database
rails db:create

# Run migrations
rails db:migrate

# Seed the database with sample data
rails db:seed
```

### 5) Start the application
```bash
# Start the Rails server
bin/dev
```

The application will be available at http://localhost:3000.

## 📊 Sample Data

The seed file creates:
- **10 companies** with names, websites, and logos
- **200 job listings** with titles, descriptions, locations, and publication dates

## 🧪 Running Tests

```bash
# Run the full test suite
bundle exec rspec
```

## 🧩 Technical Test (≈2h)

We value your time — please don’t try to cover everything.
Pick **1–2 improvements** that look most interesting to you.  
If you prefer, propose your own enhancement.

**Ideas:**

1. **pagination**: Add custom pagination to job listings (no gem like Pagy/Kaminari).
2. **filtering**: Add proper filtering / search / sort to jobs.
3. **SEO**: Improve technical SEO so the job board ranks higher.
4. **API**: Implement an API endpoint to GET or POST jobs.
5. **Cleanup**: Auto-unpublish jobs after 30 days.
6. **Job Alerts**: Let visitors create a “job alert” for new postings.
7. **Scraping**: Create jobs/companies by pasting a link from another job board.
8. **Realtime presence (Figma-style)** – Show mouse cursors of all connected visitors on the same page.  
9. **Activity tracking (analytics)** – Record page views & key actions for admins to review usage (think “lightweight analytics”, not invasive tracking).
10. **Job recommendations** – Suggest similar jobs using text similarity or tags.
11. **AI Job Category Classifier** – Classify jobs into categories (sales, marketing, engineering, etc.)

---

### 🔍 How we’ll evaluate
- **Code quality & structure** (clarity, idiomatic Rails)
- **Correctness & performance** (indexes, N+1, security)
- **Tests** (not quantity, just sensible coverage)
- **Product thinking** (scoping, trade-offs)
- **Communication** (short README / walkthrough)

---

### 📬 Submitting
- Push your changes to a public repo or branch.  
- Add a short `README_CHANGES.md`:
  - What you built & why
  - Any shortcuts or TODOs
  - What you’d do with more time
- Send an email to jeanro@ruby-on-rails-jobs.com with the link to your repo or branch.


## 📄 License

This project is for technical testing purposes only.
