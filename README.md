# Fantastical for Tuna

A [Tuna](https://tunaformac.com) extension for [Fantastical](https://flexibits.com/fantastical).
Type a sentence anywhere in Tuna and Fantastical's parser turns it into an event or task, with
inline fields for dates, alerts, calendar, notes and URL. Browse and search your agenda inside the
launcher, then reschedule, rename, relocate or delete items without opening Fantastical.

Requires Tuna 0.96 or later (TunaKit 1.22.0) and macOS 15. The agenda needs Fantastical 4.1.17 or
later (tested with 4.2, direct download build).

## What it adds

**Sources (Settings → Sources → Fantastical)**

| Catalog | ID | What it does |
| --- | --- | --- |
| Fantastical | `fantastical.agenda` | Live-search root. Press → to browse **Today**, **Tomorrow**, **This Week**, **Next 7 Days**, **This Month**, **This Quarter**, **This Year**, **Tasks**, and **By Calendar**, each with its count; type inside the root to search every event and task by name. Rows show day, time, calendar, and location. Fantastical answers at most 99 items per query; a group at that limit says so. |
| Fantastical Views | `fantastical` | Today, Tomorrow, Calendar (main window), Mini Window, one `Set: Name` entry per calendar set from settings, plus the **New Event** and **New Task** quick-capture entries. Selecting a view opens it; its Fantastical URL is the copy and text value. |
| Fantastical Calendars | `fantastical.calendars` | Hidden, target-only: your writable calendars and task lists, offered by *Add to Fantastical Calendar* and when browsing into New Event / New Task. Never appears in global search. |

**Actions (`fantastical.actions`)**

| Action | Applies to | Effect |
| --- | --- | --- |
| Show in Fantastical | a view, an agenda item | Default action (Return). Opens the view, or reveals the item's day. |
| Add to Fantastical | text, a link | Sends the sentence to Fantastical's parser through the URL scheme. Fantastical shows its preview and Return confirms; the *Add without confirmation* setting adds silently. A link's title becomes the sentence and its address is attached. |
| Add Task to Fantastical | text, a link | Same, as a task (prefixed `todo` for the parser). A date in the text becomes the due date. |
| Add to Fantastical Calendar | text, target: a calendar or task list | Same, into the chosen calendar (`/Name` for the parser). A task list makes the item a task. The target pane is scoped to your calendars and refreshes them when opened. |
| Add… | the New Event or New Task entry, target: typed text | Quick capture: select the entry, choose *Add…*, type the sentence. Browse into the entry first (→) to pick a task list or an event calendar; the child entries add into that one. |
| Search Fantastical | text | Opens Fantastical's search with the text. |
| Show Date in Fantastical | text that is one date (`2026-10-03`, `tomorrow`, `next friday`) | Reveals that day. |
| Reschedule…, Rename…, Change Location… | an agenda item, target: typed text | `modifyCalendarItem` through Fantastical's helper. Reschedule takes words such as `tomorrow 15h` or `next monday 9h to 10h`. |
| Delete from Fantastical | an agenda item | Tuna asks for confirmation, then `deleteCalendarItem` through the helper. |

Anything Fantastical's parser understands works in the sentence: `at Quick Cuts` for a location,
`/Perso` for a calendar, `alert 30 minutes`, `every tuesday`, `"quoted words"` to keep them in the
title. Emoji badges are private Flexibits data with no outside access, so an emoji you type stays in
the title.

## Fields

Details the parser cannot guess go after a **separator**. The default is `--` (two hyphens):

```
Dentist tomorrow 15h -- notes: bring the card -- cal: Perso -- alert: 30 minutes
buy printer paper -- due: next friday -- cal: My Tasks
Board meeting -- start: 2026-10-03 14:00 -- end: 2026-10-03 15:30 -- url: https://meet.example.com/x
```

Each field is `key: value`, separated from the next by another separator. Keys are case-insensitive
and a misspelled key stops the action with "Unknown field" instead of silently landing in the title.

| Field | Meaning |
| --- | --- |
| `title:` | Exact title. With no sentence before the separator nothing else is parsed, so pair it with `start:` / `end:` or `due:`. |
| `start:` / `end:` (also `from:` / `to:`) | Event start and end: `2026-10-03 14:00`, `2026-10-03`, or words such as `next friday 9h`. |
| `due:` | Task due date, same formats. |
| `allday` | Flag (or `allday: no`). |
| `cal:` or `calendar:` | Calendar or task list name as shown in Fantastical. |
| `alert:` (or `alarm:`) | Repeatable: `alert: 30 minutes -- alert: 1 day before at 9am`. |
| `url:` or `link:` | Attached URL. |
| `notes:` or `note:` | Notes. |

**Changing the separator**: Tuna Settings → Extensions → Fantastical → *Field separator*. Any token
without spaces works, for example `>>` or `;;`. The separator only counts when it stands alone
between spaces, so `https://x.com/a--b` is safe. macOS may turn `--` into an em dash while you type;
both are accepted.

Fields are translated into Fantastical's own grammar (`todo`, a quoted title, `from X to Y`,
`all day`, `alert`, `/Calendar`) because Fantastical 4.2 applies only `sentence`, `notes`, `url`
and `add` from a parse URL while its preview is open; the other documented parameters are ignored.

## Setup

1. Install Fantastical 4.1.17 or later and sign in to your calendars there.
2. Install the extension: from the Tuna Extension Store once published, or download the
   `com.brnbw.tuna.plugins.fantastical-<version>.tunaextension` from Releases and use Tuna
   Settings → Extension Store → Add from File (relaunch Tuna afterwards), or `make package` from
   this repository.
3. The first time the agenda is used, Fantastical asks whether to allow Tuna to connect. Refuse and
   the agenda shows a message instead; adding items through the URL scheme keeps working.
4. Optional settings under Tuna Settings → Extensions → Fantastical: **Add without confirmation**
   (default off), **Use the Mini Window** (default on, parse and search open in the menu bar
   window), **Field separator** (default `--`), **Calendar sets** (comma-separated names exactly as
   in Fantastical; rescan the Views source after editing).

## Privacy

Everything stays on this Mac. Creating items and opening views go through Fantastical's URL
scheme; the agenda comes from Fantastical's own MCP helper
(`Fantastical.app/Contents/Helpers/FantasticalMCP.app`) over standard input and output, one
request at a time. No network access from the extension, no credentials, no EventKit. Agenda
results live in memory only while the browse or search is open. The helper does not expose notes,
links, or a done flag, so those are not shown and tasks cannot be completed from Tuna.

Writes performed: create (URL scheme, with Fantastical's preview unless *Add without
confirmation* is on), reschedule, rename, change location (`modifyCalendarItem`), and delete
(`deleteCalendarItem`, only after Tuna's confirmation).

## Development

```bash
make build            # Debug build
make test             # unit tests
make install-restart  # install into ~/Library/Application Support/Tuna/ExtensionsDev and restart Tuna
make logs             # last 20 minutes of Tuna extension logs
make package          # Release build + dist/store/*.tunaextension
```

Or call `./scripts/tuna-extension <build|install|logs|package>` directly. Ad hoc signing is enough
for a dev install because Tuna disables library validation: `TUNA_CODE_SIGN_IDENTITY=- make
install-restart`. `./scripts/screenshot-tuna NAME [DELAY]` captures Tuna's launcher window into
`media/screenshots/NAME.png` after a delay, so you can summon Tuna first (needs Screen Recording
permission for your terminal).

The extension logs MCP traffic at info level under the subsystem
`com.brnbw.tuna.plugins.fantastical`, category `mcp`. macOS does not persist info logs, so watch
them live: `log stream --info --predicate 'subsystem == "com.brnbw.tuna.plugins.fantastical"'`.

## Releasing to the Tuna store

Store extensions ship from the [TunaExtensions](https://github.com/tunaformac/TunaExtensions)
repository, so this repo is the upstream and `FantasticalExtension/` is copied over for each
release:

1. Bump `CFBundleShortVersionString` / `CFBundleVersion` in `FantasticalExtension/Info.plist` and
   update `FantasticalExtension/CHANGELOG.md`.
2. Copy the folder into a clone of your TunaExtensions fork on a feature branch:
   `rsync -a --delete --exclude logs --exclude '*.xcuserdatad' FantasticalExtension/ ../TunaExtensions/FantasticalExtension/`
3. In that checkout: `./scripts/tuna-extension build --scheme FantasticalExtension --release`,
   `make test`, commit, push, and open or update the pull request.

The scripts under `scripts/` are copied from
[tunaformac/TunaExtensions](https://github.com/tunaformac/TunaExtensions) (MIT, see
`scripts/LICENSE-TunaExtensions`). Building needs Xcode 16+, `rg`, and network access for the
TunaKit binary package. For non-interactive signing pass `TUNA_DEVELOPMENT_TEAM` and
`TUNA_CODE_SIGN_IDENTITY` (see `security find-identity -v -p codesigning`).

### Packaging

`make package` builds Release, verifies the code signature, asks the installed Tuna binary to dump
the declaration, and writes `dist/store/com.brnbw.tuna.plugins.fantastical-<version>.tunaextension`.
Store signing happens during Tuna's review; to sign locally set `SIGNING_KEY` to an ed25519 PEM
file. Compatibility floors come from the Swift declaration (`minTuna` 0.96, `minTunaKit` 1.22.0).

## Stable identifiers

Catalog, action, item, and type IDs are public API (they end up in hotkeys, rankings, and
`tuna://` URLs). Do not rename: catalogs `fantastical`, `fantastical.agenda`,
`fantastical.calendars`, `fantastical.actions`; actions `show-in-fantastical`,
`add-to-fantastical`, `add-task-to-fantastical`, `add-to-fantastical-calendar`, `add-typed`,
`search-fantastical`, `show-date-in-fantastical`, `reschedule`, `rename`, `change-location`,
`delete-item`; items `fantastical.view.today`, `fantastical.view.tomorrow`,
`fantastical.view.calendar`, `fantastical.view.mini`, `fantastical.set.<name>`,
`fantastical.new-event`, `fantastical.new-task`; types `com.tuna.type.fantastical-destination`,
`com.tuna.type.fantastical-item`, `com.tuna.type.fantastical-calendar`; settings `AddImmediately`,
`UseMiniWindow`, `FieldSeparator`, `CalendarSets`.

## License

MIT. See `LICENSE`.
