// Package managers disagree on how to expose a package's bins: npm symlinks them, pnpm
// writes shell shims, and Yarn Berry (v2+) runs every bin through `node` and keeps the
// package itself inside a zip archive unless it is unplugged. A Node launcher is the only
// entrypoint all of them run the same way, so the bins are these launchers and they hand
// off to the bash scripts, which live next to each other in the (unplugged, see
// `preferUnplugged` in package.json) package directory.
import { spawn } from "node:child_process";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const PACKAGE_DIR = join(dirname(fileURLToPath(import.meta.url)), "..");

export function run(script) {
  const child = spawn("bash", [join(PACKAGE_DIR, script), ...process.argv.slice(2)], {
    stdio: "inherit",
  });

  // Ctrl-C reaches the whole foreground process group, so the child already gets it. Stay
  // alive until it exits (e.g. `gaztec start --local-network` shutting down) and relay
  // signals that were sent to this process only.
  for (const signal of ["SIGINT", "SIGTERM", "SIGHUP"]) {
    process.on(signal, () => {
      if (signal !== "SIGINT") child.kill(signal);
    });
  }

  child.on("error", (error) => {
    console.error(`gaztec: failed to run bash: ${error.message}`);
    process.exit(1);
  });

  child.on("exit", (code, signal) => {
    if (signal) {
      process.removeAllListeners(signal);
      process.kill(process.pid, signal);
    } else {
      process.exit(code ?? 1);
    }
  });
}
