[![tests](https://github.com/platformsh/ddev-platformsh/actions/workflows/tests.yml/badge.svg)](https://github.com/platformsh/ddev-platformsh/actions/workflows/tests.yml) ![project is maintained](https://img.shields.io/maintenance/yes/2022.svg)

## What is ddev-platformsh?

This repository is used with `ddev get platformsh/ddev-platformsh` to get a rich integration between your checked-out Platform.sh project and [DDEV](https://github.com/drud/ddev).

## Using with a Platform.sh project
1. Make sure you have [DDEV v1.21.1+ installed](https://ddev.readthedocs.io/en/latest/users/install/ddev-installation/)
2. Clone your project repository (e.g. `platform get <projectid>`)
3. `cd` into your project directory
4. Run `ddev config` and answer the questions as appropriate
5. Run `ddev get platformsh/ddev-platformsh` and answer the questions as appropriate
6. Run `ddev start`
7. (Optional) Run `ddev pull platform` to retrieve a copy of the database and contents from the project's file mounts from the environment you entered in step #5
   1. If you only want to retrieve the database (skipping the file mounts), add the `--skip-files` flag to the `ddev pull platform` command

## Notes

* If your local project has a different database type than the upstream (Platform.sh) database, it will conflict, so please back up your database with `ddev export-db` and `ddev delete -y` before starting the project with new config based on upstream.
* Your experience is super-important: Please let us know about how it went for you in any of the [DDEV support venues](https://ddev.readthedocs.io/en/latest/#support-and-user-contributed-documentation)

## What does it do right now?

* Takes your checked-out Platform.sh project and configures DDEV based on that information.
    * PHP and Database version
    * hooks are converted to DDEV post-start hooks
    * A working `ddev pull platform` integration with all mounts is created.
    * Exposes specific `$PLATFORM_` variables (e.g., `$PLATFORM_RELATIONSHIPS`)
* Supports the following services:
    * Databases
      * MariaDB
      * Oracle MySQL
      * Postgresql
    * Redis
    * Memcached
    * ElasticSearch

## What has been tested

These Platform.sh templates are included in the automated tests that run nightly. They will be growing in maturity with your feedback!

* [php](https://github.com/platformsh-templates/php)
* [drupal9](https://github.com/platformsh-templates/drupal9) and [drupal8](https://github.com/platformsh-templates/drupal8)
* [laravel](https://github.com/platformsh-templates/laravel)
* [wordpress-composer](https://github.com/platformsh-templates/wordpress-composer)

## What will it do in the future

- [x] Populate important PLATFORMSH environment variables that would be found upstream
- [x] Populate PHP and other dependencies configured upstream
- [x] Automatically figure out the name and other information of the upstream project
- [x] Automatically configure the .ddev/providers/platform so you can immediately do a `ddev pull platform` with no configuration effort.
- [ ] Let us know what's important to you!

**Contributed and maintained by [@rfay](https://github.com/rfay) and [@lolautruche](https://github.com/lolautruche)**


