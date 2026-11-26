# Salgsdemo

En bevisst enkel webside som brukes til å demonstrere hvordan en AI-assistent kan hente informasjon
fra et GitHub-repository og overføre den til et annet system ved hjelp av
[Model Context Protocol (MCP)](https://modelcontextprotocol.io).

**Live:** https://salgsdemo.skydotten.no

## Hva siden viser

- Overskriften «Velkommen til Demoen»
- Dagens dato (oppdateres i nettleseren)
- En kort forklaring av hva demoen handler om
- En lenke tilbake til dette repoet
- Versjonsnummer nede til høyre

## Versjonsnummer

Formatet er `ÅÅÅÅ.MM.DD.<build>`, for eksempel `2026.11.26.3`.

- Datoen er dagen siden ble bygget.
- Build er antall commits på `main`, så hver endring som merges gir et nytt og stigende nummer.

Versjonen er også tilgjengelig som JSON på `/version.json`.

## Teknisk

| Del | Valg |
|---|---|
| Server | Node 24, kun innebygde moduler (`node:http`), ingen npm-avhengigheter |
| Frontend | Én HTML-fil i `public/index.html` |
| Kjøring | Docker / Docker Compose |
| CI | GitHub Actions (syntakssjekk + røyktest av image) |
| Deploy | Serveren henter `main` automatisk og bygger på nytt |

### Kjør lokalt

```bash
docker build -t salgsdemo --build-arg APP_VERSION=dev .
docker run --rm -p 3000:3000 salgsdemo
# åpne http://localhost:3000
```

### Endepunkter

| Sti | Innhold |
|---|---|
| `/` | Selve siden |
| `/version.json` | `{ version, build_date, commit, repo }` |
| `/healthz` | `ok` |
