# StudyFlow
Pomodoro study timer + analytics. Plain HTML/JS, Supabase (Postgres + Auth) as the database, offline-first.

## 1. Create the database (free)
1. Go to supabase.com, create a project, wait until it is ready.
2. SQL Editor -> New query -> paste `supabase/schema.sql` -> Run.
3. Project Settings -> API: copy the **Project URL** and the **anon public** key.
4. Open `index.html`, find `SUPABASE_URL` / `SUPABASE_ANON_KEY` near the top of the script and paste them in.
   (The anon key is safe in the browser because row-level security limits each user to their own rows. Never put the service_role key here.)
5. Authentication -> URL Configuration: set Site URL to `http://127.0.0.1:5500` and add your GitHub Pages URL under Redirect URLs.
6. Optional for testing: Authentication -> Providers -> Email -> turn off "Confirm email".

## 2. Run locally
VS Code -> install **Live Server** -> right-click `index.html` -> Open with Live Server.

## 3. Push to GitHub
    git init && git add . && git commit -m "StudyFlow with Supabase"
    git branch -M main
    git remote add origin https://github.com/YOUR-USERNAME/studyflow.git
    git push -u origin main
Then repo Settings -> Pages -> Deploy from branch `main` / root.

## How the data works
- The timer and sessions save on the device first (works offline, survives restarts), then sync to Supabase.
- Sessions are merged by ID, so nothing duplicates. Profile, subjects, settings and timer use last-write-wins.
- Log in on any device with the same email to get your data back, even after clearing the browser.
