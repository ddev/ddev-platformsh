[![tests](https://github.com/platformsh/ddev-platformsh/actions/workflows/tests.yml/badge.svg)](https://github.com/platformsh/ddev-platformsh/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2022.svg)

## What is ddev-psh-auto-id?

This repository is used with `ddev get bserem/ddev-psh-auto-id` to get a rich integration between your checked-out
Platform.sh project and [DDEV](https://github.com/drud/ddev).

It is a fork of `platformsh/ddev-platformsh` that automatically loads the Platform Project ID
**if** `.platform/local/project.yaml` exists in your repo.

## Installing

* If your local project has a different database type than the upstream (Platform.sh) database, it will conflict, so please back up your database with `ddev export-db` and `ddev delete -y` before starting the project with new config based on upstream.
* This requires DDEV v1.21.1+.
* `ddev get bserem/ddev-psh-auto-id` and `ddev restart`
* Your experience is super-important: Please let us know about how it went for you in any of the [DDEV support venues](https://ddev.readthedocs.io/en/latest/#support-and-user-contributed-documentation)

## What does it do right now?

* Takes your checked-out Platform.sh project and configures DDEV based on that information.
  * PHP and Database version
  * hooks are converted to DDEV post-start hooks
  * A working `ddev pull platform` integration with all mounts is created.
  * Populates project ID in DDEV automatically
  

## What will it do in the future

- [x] Populate important PLATFORMSH environment variables that would be found upstream
- [ ] Populate PHP and other dependencies configured upstream
- [x] Automatically figure out the name and other information of the upstream project
- [x] Automatically configure the .ddev/providers/platform so you can immediately do a `ddev pull platform` with no configuration effort.
- [ ] Let us know what's important to you!

**Contributed and maintained by [@rfay](https://github.com/rfay), [@lolautruche](https://github.com/lolautruche) and [@bserem](https://github.com/bserem)**


