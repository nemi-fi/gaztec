# Aztec version manager

Manage your `aztec` versions without hussle. Automatically switch between versions in projects by creating a `.gaztecrc` file.

## Installation

```sh
npm i -g gaztec
```

You can also install it locally and use it in your project:

```sh
npm i gaztec -D
```

**WARNING**: if you use `pnpm` or `yarn`, you must use `npx gaztec` instead of `pnpm gaztec` or `yarn gaztec`.

## Use in your project

```sh
# create a file that defines the version of Aztec for your project
echo "4.0.0-nightly.20260218" > .gaztecrc

# use `gaztec` where you would use `aztec`
gaztec --version
#> 4.0.0-nightly.20260218
```
