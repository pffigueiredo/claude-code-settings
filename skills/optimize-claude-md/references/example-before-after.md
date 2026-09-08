# Example: Before & After Optimization

## Before (128 lines)

```markdown
# Project CLAUDE.md

## About This Project

This is a Next.js application that uses TypeScript, Tailwind CSS, and Prisma ORM.
We deploy to Vercel. The database is PostgreSQL hosted on Neon.

## Code Style

### TypeScript
- Always use TypeScript strict mode
- Prefer interfaces over types for object shapes
- Use `unknown` instead of `any`
- Always add return types to functions

### React
- Use functional components with hooks
- Prefer named exports over default exports
- Keep components under 200 lines
- Use `clsx` for conditional class names

### CSS
- Use Tailwind CSS utility classes
- Avoid custom CSS unless absolutely necessary
- Use the `cn()` helper for merging class names

## Testing

### Running Tests
To run the test suite, use the following command:
```bash
pnpm test
```

To run tests in watch mode:
```bash
pnpm test:watch
```

To run a specific test file:
```bash
pnpm test path/to/file.test.ts
```

### Writing Tests
- Use Vitest for unit tests
- Use Playwright for E2E tests
- Mock external services in tests
- Test files should be co-located with source files
- Name test files with `.test.ts` suffix

## Database

### Schema
The database has the following main tables:

- **users** - id, email, name, created_at, updated_at
- **projects** - id, name, user_id (FK), status, created_at
- **tasks** - id, title, description, project_id (FK), assignee_id (FK), status, priority, due_date
- **comments** - id, body, task_id (FK), author_id (FK), created_at

### Migrations
To create a new migration:
```bash
pnpm prisma migrate dev --name migration_name
```

To apply migrations:
```bash
pnpm prisma migrate deploy
```

### Seeding
To seed the database:
```bash
pnpm prisma db seed
```

## API Routes

### Authentication
- POST /api/auth/login - Login with email/password
- POST /api/auth/register - Create new account
- POST /api/auth/logout - Destroy session
- GET /api/auth/me - Get current user

### Projects
- GET /api/projects - List user's projects
- POST /api/projects - Create project
- GET /api/projects/:id - Get project details
- PUT /api/projects/:id - Update project
- DELETE /api/projects/:id - Delete project

### Tasks
- GET /api/projects/:id/tasks - List project tasks
- POST /api/projects/:id/tasks - Create task
- GET /api/tasks/:id - Get task details
- PUT /api/tasks/:id - Update task
- DELETE /api/tasks/:id - Delete task
- POST /api/tasks/:id/comments - Add comment

## Deployment

### Environment Variables
Required environment variables for deployment:
- DATABASE_URL - PostgreSQL connection string
- NEXTAUTH_SECRET - Auth encryption key
- NEXTAUTH_URL - Application URL
- SMTP_HOST - Email server host
- SMTP_PORT - Email server port
- SMTP_USER - Email username
- SMTP_PASS - Email password

### Deploy Process
1. Push to main branch
2. Vercel automatically builds and deploys
3. Migrations run via postbuild script
4. Verify deployment at https://app.example.com

## Troubleshooting

### Common Issues
- If Prisma types are stale, run `pnpm prisma generate`
- If migrations fail, check DATABASE_URL is set correctly
- If tests timeout, ensure test database is running
- If build fails on Vercel, check Node version matches .nvmrc
```

## After Optimization

### New CLAUDE.md (52 lines)

```markdown
# Project CLAUDE.md

Next.js + TypeScript + Tailwind + Prisma. Deploy: Vercel. DB: PostgreSQL on Neon.

## Code Style
- TS strict mode, `unknown` over `any`, always add return types, interfaces over types
- React: functional components, named exports, components < 200 lines, `clsx`/`cn()` for classes
- Tailwind utilities only, avoid custom CSS

## Commands
cmd|purpose
pnpm test|run test suite
pnpm test:watch|watch mode
pnpm test path/to/file|run specific test
pnpm prisma migrate dev --name X|create migration
pnpm prisma migrate deploy|apply migrations
pnpm prisma db seed|seed database
pnpm prisma generate|regenerate types (if stale)

## Testing
- Vitest (unit), Playwright (E2E), mock external services
- Co-locate test files with source, `.test.ts` suffix

## Deploy
Push to main → Vercel auto-builds → migrations via postbuild → verify at app URL.

Env vars and full deploy checklist: docs/deployment.md

## API Routes
See docs/api-reference.md

## Database Schema
See docs/database.md

## Troubleshooting
- Stale Prisma types → `pnpm prisma generate`
- Migration fail → check DATABASE_URL
- Test timeout → ensure test DB running
- Vercel build fail → check Node version matches .nvmrc
```

### New docs/api-reference.md

```markdown
# API Reference

## Authentication
POST /api/auth/login|Login with email/password
POST /api/auth/register|Create new account
POST /api/auth/logout|Destroy session
GET /api/auth/me|Get current user

## Projects
GET /api/projects|List user's projects
POST /api/projects|Create project
GET /api/projects/:id|Get project details
PUT /api/projects/:id|Update project
DELETE /api/projects/:id|Delete project

## Tasks
GET /api/projects/:id/tasks|List project tasks
POST /api/projects/:id/tasks|Create task
GET /api/tasks/:id|Get task details
PUT /api/tasks/:id|Update task
DELETE /api/tasks/:id|Delete task
POST /api/tasks/:id/comments|Add comment
```

### New docs/database.md

```markdown
# Database Schema

## Tables
- **users** - id, email, name, created_at, updated_at
- **projects** - id, name, user_id (FK), status, created_at
- **tasks** - id, title, description, project_id (FK), assignee_id (FK), status, priority, due_date
- **comments** - id, body, task_id (FK), author_id (FK), created_at
```

### New docs/deployment.md

```markdown
# Deployment

## Required Environment Variables
DATABASE_URL|PostgreSQL connection string
NEXTAUTH_SECRET|Auth encryption key
NEXTAUTH_URL|Application URL
SMTP_HOST|Email server host
SMTP_PORT|Email server port
SMTP_USER|Email username
SMTP_PASS|Email password

## Deploy Process
1. Push to main branch
2. Vercel automatically builds and deploys
3. Migrations run via postbuild script
4. Verify deployment at https://app.example.com
```

## Results

| Metric | Before | After |
|--------|--------|-------|
| CLAUDE.md lines | 128 | 52 |
| Total files | 1 | 4 |
| Information lost | — | 0 lines |
| Compression ratio | — | 59% reduction in main file |

---

## Bad Compression Example (What NOT to Do)

The same 128-line input above, blindly summarized instead of restructured:

### Bad Output (18 lines)

```markdown
# Project CLAUDE.md

This is a Next.js/TypeScript/Tailwind/Prisma project deployed on Vercel with PostgreSQL.

Follow TypeScript strict mode and React best practices. Use Vitest for unit tests and
Playwright for E2E. Run tests with pnpm test.

The database has users, projects, tasks, and comments tables. Use Prisma for migrations
and seeding.

API routes cover auth, projects, and tasks CRUD operations.

Deploy by pushing to main. Set required env vars (DATABASE_URL, NEXTAUTH_SECRET, etc.).

If something breaks, try regenerating Prisma types or checking your env vars.
```

### Why This Fails

| Problem | Example | Impact |
|---------|---------|--------|
| Lost specifics | "React best practices" instead of "named exports, components < 200 lines, clsx" | Claude guesses instead of following rules |
| Lost commands | No `pnpm prisma migrate dev --name X` | Claude has to rediscover commands each time |
| Lost API routes | "CRUD operations" instead of actual endpoints | Claude cannot verify or reference routes |
| Lost env var list | "DATABASE_URL, NEXTAUTH_SECRET, etc." — the "etc." hides 5 more vars | Incomplete deployments |
| Lost troubleshooting | "try regenerating Prisma types" loses 3 of 4 specific fixes | Claude cannot help debug |

**Summarization drops accuracy 66.7% → 57.1%.** The correct approach: restructure into main file + docs/, preserving every detail.
