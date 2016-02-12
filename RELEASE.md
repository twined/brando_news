# Release Instructions

  1. git-flow: Start release. Tag without "v", e.g. 0.1.0 - NOT v0.1.0!
  2. Bump version in `CHANGELOG`
  3. Bump version in `mix.exs`
  4. Bump version in `package.json`
  5. Bump version in `README.md` installation instructions (if we add to hex)
  6. Update translations:
     `$ mix gettext.extract && mix gettext.merge priv/gettext`
  7. `$ mix test`
  8. Commit with `Prepare X.X.X release`
  9. git-flow: finish release. Tag without "v", e.g. 0.1.0 - NOT v0.1.0!
     - tag message: Release vX.X.X
  10. Switch to master. Push.
  11. Push `X.X.X` tag to `origin`
  12. (Push package and docs to hex)
  13. Switch to develop-branch.
  14. Bump version in CHANGELOG + -dev
  15. Bump version in mix.exs + -dev
  16. Bump version in package.json + -dev  
  17. Commit `develop` with `Start X.X.X development`. Push
