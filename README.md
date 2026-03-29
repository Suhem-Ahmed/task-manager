📘 Learning Tasks Manager (Static Website)
Overview

Learning Tasks Manager is a single-file, fully static web app (index.html) to manage daily learning tasks.

No backend required
Works entirely in your browser
Data stored locally using localStorage
Supports full backup and restore via JSON
🚀 Getting Started
Download or save the index.html file
Open it in any modern browser (Chrome, Edge, Firefox)
Start adding and managing your tasks
🧩 Features
1. Home (Daily View)
Select a date (YYYY-MM-DD)
View all tasks across categories for that date
See counts: Total / Done / Pending
Export selected date as CSV
2. Categories

Default categories:

Day2Day
TASKS
BASH SCRIPTING

You can:

Add new categories
Rename existing categories
Delete categories (with confirmation)
3. Task Management

Each task includes:

Category
Date
Task text
Optional comment
Done status

You can:

Add new tasks
Edit tasks
Delete tasks (with confirmation)
Toggle Done/Undone
Mark all tasks in a category as Done
4. Import / Export
Export Options
Export all data as JSON (full backup)
Export all tasks as CSV
Export category-specific CSV
Export date-specific CSV
Import Options
Upload a JSON file
Choose mode:
Merge → adds data safely without removing existing data
Replace → completely overwrites current data

Preview is shown before confirming import.

5. Undo
Supports one-step undo
Works for destructive actions:
Delete task
Delete category
Undo resets after next action or page reload
💾 Data Storage
Stored in browser using localStorage

Key used:

learningTasksData_v4
First-time use automatically loads sample data

⚠️ Important:
Data will be lost if browser storage is cleared — always export JSON for backup.

🔐 Data Safety Tips
Regularly export JSON backups
Export before deleting categories
Use Merge mode when unsure during import
📱 Mobile Support
Fully responsive design
Sidebar becomes a slide-out menu
Tables convert into mobile-friendly cards
🛠 Customization

At the top of the script, you can modify:

Storage keys
Default categories

Example:

const DEFAULT_CATEGORIES = ["Day2Day", "TASKS", "BASH SCRIPTING"];
📌 Notes
No internet required after loading
No external dependencies (except optional fonts)
Works offline
Designed for simplicity and auditability
✅ Summary

This app is ideal if you:

Previously used spreadsheets for task tracking
Want a lightweight offline tool
Need full control over your data
Prefer a simple, clean UI