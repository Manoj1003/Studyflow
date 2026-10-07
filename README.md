# StudyFlow

A cozy, offline-first **study timer and productivity dashboard** for students preparing for competitive exams (built for GATE 2027, but the exam name, date and subjects are all editable).

Plain HTML, CSS and JavaScript in a single `index.html`, with **Supabase** (Postgres + Auth) as the database. No build step.

## Features

**Timer**
- Editable Pomodoro: study, short break, long break and sessions before a long break (default 50 / 10 / 30 / 4).
- Start, pause, resume, reset, skip, and ±5 minutes. Skip cycles Study → Short break → Long break.
- Timestamp-based: the timer stores absolute times, not a ticking counter, so it stays correct after closing the browser, sleeping the laptop, going offline or restarting.
- Alarm with 10 built-in sounds, volume control, test button and browser notifications.
- Pop-out timer with a large play/pause button. It uses a Document Picture-in-Picture window in Chrome and Edge (resizable, the timer scales to fit) and falls back to a draggable floating timer elsewhere.
- Fullscreen mode and keyboard shortcuts: `Space` start/pause, `R` reset, `S` skip, `P` pop-out, `F` fullscreen, `Esc` close, `?` help.

**Tracking and analytics** (all update live while a session runs)
- Countdown to your exam date (name and date editable in Settings).
- Subjects: add, rename, recolour, delete. Study time shown next to each subject.
- GitHub-style activity heatmap for the last 12 months (months across the top, today outlined), or any year or custom range.
- Study-hours line graph: a 24-hour day view (per hour or cumulative) plus 7-day to 1-year views. Click a point to see which subjects you studied and for how long.
- Subject pie chart, daily goal bar, streaks (configurable minimum minutes), averages, most productive day and time, and a calendar with day details.

**Accounts and data**
- Opens on the home page as a guest. Use **Log in / Sign up** in the top-right corner. Once logged in you stay logged in until you log out.
- Guest sessions are added to your account when you log in.
- Local-first: data is saved in the browser first, then synced to Supabase. Sessions merge by ID so nothing duplicates.
- Profile photo with drag-and-drop upload and a crop, zoom, rotate and brightness editor.
- Light, dark or system theme with an accent colour. Responsive for phones, tablets and laptops.
- Installable as a PWA (service worker and manifest included).

## Quick start

1. Clone the repo:
   ```bash
   git clone https://github.com/Manoj1003/Strudyflow.git
   cd Strudyflow
   ```
2. Open the folder in VS Code, install the **Live Server** extension, right-click `index.html` and choose **Open with Live Server**. Use a local server rather than double-clicking the file, because the pop-out timer and PWA need one.

Without any setup the app already works as a guest, saving to your browser only.

## Enable login and the cloud database (Supabase)

1. Create a free project at [supabase.com](https://supabase.com).
2. In **SQL Editor → New query**, paste the contents of `supabase/schema.sql` and click **Run**. This creates the `profiles` and `sessions` tables with row-level security, so each user can only access their own rows.
3. In **Project Settings → API Keys**, copy your **Project URL** and your **Publishable key** (or the legacy **anon** key).
4. In `index.html`, find this line near the top of the script and fill in your values:
   ```js
   const SUPABASE_URL='https://YOUR-PROJECT.supabase.co',SUPABASE_ANON_KEY='YOUR-KEY';
   ```
5. In **Authentication → URL Configuration**, set the Site URL to `http://127.0.0.1:5500` and add your deployed address under Redirect URLs.
6. Optional while testing: **Authentication → Providers → Email**, turn off "Confirm email".

> The publishable or anon key is designed to be public. **Never** put the `service_role` or secret key in this project.

## Deploy free on GitHub Pages

1. Push the project to GitHub.
2. Repo **Settings → Pages → Deploy from a branch → main / (root) → Save**.
3. Your site goes live at `https://YOUR-USERNAME.github.io/REPO-NAME/`. Add that address to Supabase **Redirect URLs** too.

## Project structure

```
index.html            the whole app (HTML, CSS, JS)
sw.js                 service worker (offline caching)
manifest.webmanifest  PWA manifest
icon-192.png          app icons
icon-512.png
supabase/schema.sql   database tables, row-level security policies and delete-account function
README.md
```

## How syncing works

- Timer state, sessions, subjects and settings are saved to `localStorage` on every change, so the app works fully offline.
- When online, the app syncs a couple of seconds after a change, once a minute, when you return to the tab and when the connection comes back.
- Sessions are keyed by ID and merged without duplicates. Subjects, settings and the live timer use last-write-wins by timestamp.
- Logging in on another device with the same email downloads your data, even after clearing browser storage.

## Good to know

- A study session counts toward the live stats from the moment it starts, but is only saved to history if it runs at least 60 seconds or finishes.
- The subject is locked while a session is running.
- The alarm only plays while the page is open, because browsers don't run timers for closed pages. If a timer ends while the page is closed, the session is recorded correctly and a banner appears when you reopen it.
- Guest data lives only in that browser. Clearing site data erases it, so log in to back it up.
- Password reset sends an email through Supabase Auth.

## Tech

HTML, CSS and vanilla JavaScript · Supabase (Postgres, Auth, Row Level Security) · Service Worker + Web App Manifest · Document Picture-in-Picture API
