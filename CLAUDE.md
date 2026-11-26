# Salgsdemo – regler for agenter

Gjelder alle AI-agenter, uansett leverandør.

- Produksjon: ContainerOne (Skydotten), mappe `/home/tommy/salgsdemo`, https://salgsdemo.skydotten.no
  (host-port `127.0.0.1:3023` → container `3000`). Container: `salgsdemo-web`.
- NPM proxy host peker på `salgsdemo-web:3000` (containernavn, aldri IP). Wildcard-sertifikat `*.skydotten.no`.
- **Offentlig side og offentlig repo.** Ikke bak Cloudflare Access. Ingen hemmeligheter, interne adresser eller
  kundedata i repoet – alt her er synlig for alle.
- Teksten på siden skal være generisk og ikke nevne noe firmanavn.
- **Aldri push direkte til `main`.** Jobb på `feat/mgmt-<id>-...` / `fix/mgmt-<id>-...`, åpne PR og vent på
  eksplisitt «ja»/«merge» fra Tommy. Squash merge.
- CI kjører på GitHub-hostede runnere (`.github/workflows/ci.yml`). Det er **bevisst ingen self-hosted runner**,
  fordi repoet er public og PR-er fra forks ellers kunne kjørt kode på serveren.
- Deploy: `auto-deploy.sh` kjøres av cron på serveren hvert 2. minutt, henter `origin/main` og kjører `deploy.sh`
  ved nye commits. Ikke kjør `docker compose` manuelt etter merge. Logg: `/home/tommy/scripts/logs/salgsdemo-deploy.log`.
- Versjon: `ÅÅÅÅ.MM.DD.<antall commits på main>`, satt i `deploy.sh` og bakt inn i imaget som build-args.
- Ingen npm-avhengigheter. Hold det slik med mindre Tommy ber om noe annet.
