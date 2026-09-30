# Interview Prep Desk

Single-page tool: paste a job (text or link) and your résumé (paste or upload), get 10 tailored interview questions, star the good ones, generate more, and save each job to your account.

## Deploy (Vercel + Supabase)

1. Create a Supabase project.
2. SQL editor: run [schema.sql](schema.sql).
3. Authentication → Providers → Email: turn **Confirm email OFF**. (Usernames are mapped to hidden emails like `name@users.interviewprep.app`; no mail is ever sent.)
4. In `index.html`, set `SUPABASE_URL` and `SUPABASE_ANON_KEY` (Project Settings → API). The anon key is public by design; Row Level Security in `schema.sql` is what protects each user's data.
5. Deploy this folder to Vercel as a static site (no build command, no output directory).

Without those two values the page runs in **demo mode**: no accounts, data saved only in that browser.

## Notes

- Accounts are optional. Guests can use everything; their prep is saved in that browser only (lost if site data is cleared). After signing in, guest jobs can be moved into the account.
- Each user pastes their own Anthropic API key. It stays in their browser (optionally remembered in localStorage) and is never stored in Supabase.
- Forgotten passwords can't be reset yet. The optional recovery email is stored for a future reset flow.
- The full résumé and job text are not stored; only short summaries used to generate additional questions.
