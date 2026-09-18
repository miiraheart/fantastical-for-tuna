# Fantastical for Tuna

A [Tuna](https://tunaformac.com) extension for [Fantastical](https://flexibits.com/fantastical).
Type a sentence and Fantastical's parser turns it into an event or task, with inline fields for
dates, alerts, calendar, notes and URL. Browse and search your agenda inside Tuna, then reschedule,
rename, relocate or delete items without leaving the launcher.

Requires Tuna 0.96 or later (TunaKit 1.22.0), macOS 15, and Fantastical 4.1.17 or later for the
agenda (tested with 4.2). Everything stays on your Mac: Fantastical's URL scheme for creating
items and views, its bundled MCP helper for reading the agenda; no network, no credentials.

## Install

- **Tuna Extension Store**: once the extension is published there, add it from Tuna Settings >
  Extension Store.
- **Package**: download `com.brnbw.tuna.plugins.fantastical-<version>.tunaextension` from the
  Releases page, then Tuna Settings > Extension Store > Add from File. Relaunch Tuna afterwards.
- **From source**: `make package` writes the same file to `dist/store/`.

## Usage

Everything you can type, browse and configure is documented in
[FantasticalExtension/README.md](FantasticalExtension/README.md): adding events and tasks, the
field separator and every field, New Event / New Task entries, the agenda, views, settings,
privacy and limitations. Release notes live in
[FantasticalExtension/CHANGELOG.md](FantasticalExtension/CHANGELOG.md).

## Development

```bash
make build            # Debug build
make test             # unit tests
make install-restart  # dev-install into Tuna and relaunch it
make logs             # extension log lines from the last 20 minutes
make package          # Release build + .tunaextension in dist/store
```

Ad hoc signing is enough for a dev install: `TUNA_CODE_SIGN_IDENTITY=- make install-restart`.
The extension is also submitted to [tunaformac/TunaExtensions](https://github.com/tunaformac/TunaExtensions)
for the Tuna Extension Store; the build scripts under `scripts/` come from that repository
(see `scripts/LICENSE-TunaExtensions`).

## License

MIT, see [LICENSE](LICENSE).
