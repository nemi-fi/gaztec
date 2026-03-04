# Contributing

## Releasing

Releases are automated with [release-please](https://github.com/googleapis/release-please). Use [Conventional Commits](https://www.conventionalcommits.org/) in your PRs (`feat:`, `fix:`, etc.). When a Release PR is merged, it will:

1. Create a GitHub release and tag
2. Publish to npm

**Required secret:** Add `NPM_TOKEN` (npm automation token) to your repo secrets for publishing. Create one at npmjs.com → Account → Access Tokens.
