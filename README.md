# Aztec version manager

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
echo "2.0.3" > .gaztecrc

# use `gaztec` where you would use `aztec`
gaztec --version
#> 2.0.3
```
