# Aztec version manager

Manage your `aztec` versions without hassle. Automatically switch between versions in projects by creating a `.aztecrc` file.

## Why gaztec?

- **No installation** — just run `npx gaztec` and go. No global install, no `npm i` required
- **Automatic version switching** — drop a `.aztecrc` in your project and gaztec picks the right version
- **No `aztec-up` needed** — versions are fetched on demand when you run a command
- **Simple** — `npx gaztec <command>` replaces `aztec <command>` everywhere

## Quick start

```sh
# create a file that defines the version of Aztec for your project
echo "4.0.0-devnet.2-patch.2" > .aztecrc

# use gaztec where you would use aztec (no install needed)
npx gaztec --version
#> 4.0.0-devnet.2-patch.2
```

## Installation (optional)

You can install gaztec globally or as a dev dependency (to pin the version) if you prefer:

```sh
npm i -g gaztec
# or
npm i gaztec -D
```

**Note**: with `pnpm` or `yarn`, use `npx gaztec` instead of `pnpm gaztec` or `yarn gaztec`.

## CI

Commit a `.aztecrc` file to your repo and use `npx gaztec` in your workflow. No setup step needed:

```yaml
name: Test

on: [push]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 24

      - name: Compile Aztec contracts
        run: npx gaztec compile

      - name: Start Aztec Local Network
        run: npx gaztec start --local-network
```

## Compatibility with `aztec`

| gaztec version | aztec version |
| -------------- | ------------- |
| < 1.0.0        | < 4.0.0       |
| >= 1.0.0       | >= 4.0.0      |
