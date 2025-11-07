# Trekka API (NestJS)

This NestJS service is part of the Trekka monorepo. Centralized documentation now lives at the repository root.

- Repository overview & setup (including API commands): `../../README.md`
- Contribution workflow & coding standards: `../../CONTRIBUTING.md`

API quick reference:

```bash
npm install
npm run start:dev
npm run test
npm run lint
```

Utility scripts such as `npm run generate:key` rely on the shared `../../scripts` directory.

## Run with Docker

The API and Postgres database can now be launched together with Docker Compose.

```bash
cp .env.example .env # configure secrets if you have not already
docker compose up --build
```

What happens:
- Postgres starts with a persistent volume (`pg_data`) so your data survives restarts.
- The API container waits for Postgres, runs Prisma migrations, seeds the Hedera demo data (required on every fresh database), and then starts `nest start --watch`.
- Your local source code is mounted into the container so edits trigger live reloads.

Seeding needs valid Hedera credentials in `.env` (`HEDERA_OPERATOR_ID` / `HEDERA_OPERATOR_KEY`). The container will exit if they are missing—set `SKIP_DB_SEED=true` explicitly when you want to boot without the demo wallets.

Useful follow-up commands:

```bash
docker compose logs -f api        # tail the NestJS logs
docker compose down               # stop the stack but keep data
docker compose down -v            # destroy the database volume and start fresh next time
SKIP_DB_SEED=true docker compose up  # skip the seed step when booting
```

The existing npm helpers (`npm run docker:up`, `npm run docker:down`, etc.) call the same Compose file, so you can continue using them if you prefer.
