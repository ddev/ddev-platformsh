[![tests](https://github.com/platformsh/ddev-platformsh/actions/workflows/tests.yml/badge.svg)](https://github.com/platformsh/ddev-platformsh/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2022.svg)

## What is ddev-platformsh?

This repository is used with `ddev get platformsh/ddev-platformsh` to get a rich integration between your checked-out Platform.sh project and [DDEV](https://github.com/drud/ddev).

## Installing

* If your local project has a different database type than the upstream (Platform.sh) database, it will conflict, so please back up your database with `ddev export-db` and `ddev delete -y` before starting the project with new config based on upstream.
* This currently requires DDEV HEAD, but the features required will be in DDEV v1.19.4. You can install DDEV HEAD with `brew unlink ddev && brew install --HEAD --fetch-head drud/ddev/ddev`
* `ddev get platformsh/ddev-platformsh` and `ddev restart`
* Your experience is super-important: Please let us know about how it went for you in any of the [DDEV support venues](https://ddev.readthedocs.io/en/latest/#support-and-user-contributed-documentation)

## What does it do right now?

* Takes your checked-out Platform.sh project and configures DDEV based on that information.
  * PHP and Database version
  * hooks are converted to DDEV post-start hooks
  

## What will it do in the future

- [ ] Populate important PLATFORMSH environment variables that would be found upstream
- [ ] Populate PHP and other dependencies configured upstream
- [ ] Automatically figure out the name and other information of the upstream project
- [ ] Automatically configure the .ddev/providers/platform so you can immediately do a `ddev pull platform` with no configuration effort.
- [ ] Let us know what's important to you!

**Contributed and maintained by [@rfay](https://github.com/rfay) and [@lolatruche](https://github.com/lolatruche)**


