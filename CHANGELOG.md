# Changelog

## [1.1.6](https://github.com/dkarter/cookie_monster/compare/v1.1.5...v1.1.6) (2023-12-08)


### Bug Fixes

* decode header with unsupported directive ([#18](https://github.com/dkarter/cookie_monster/issues/18)) ([332720f](https://github.com/dkarter/cookie_monster/commit/332720f261aa554fe30ddf380071231c74ef9149))

## [1.1.5](https://github.com/dkarter/cookie_monster/compare/v1.1.4...v1.1.5) (2023-10-19)


### Bug Fixes

* accept short weekday format for weekday names ([#16](https://github.com/dkarter/cookie_monster/issues/16)) ([fd83cc1](https://github.com/dkarter/cookie_monster/commit/fd83cc1b0a9b371d8beb47af54ba72996e4d35f7))

## [1.1.4](https://github.com/dkarter/cookie_monster/compare/v1.1.3...v1.1.4) (2023-10-15)


### Bug Fixes

* cookie type max_age was incorrect ([c5de17f](https://github.com/dkarter/cookie_monster/commit/c5de17f2f787fffb9507a3b96f374c661b9f1c0a))
* correctly document private modules ([f767ec8](https://github.com/dkarter/cookie_monster/commit/f767ec837eec23a062998aca56e1572188fd5959))
* parse max_age to integer correctly ([0ada60c](https://github.com/dkarter/cookie_monster/commit/0ada60cc33c810d1427a87210d7ab003b30faa4e))

## [1.1.3](https://github.com/dkarter/cookie_monster/compare/v1.1.2...v1.1.3) (2023-10-15)


### Miscellaneous Chores

* release 1.1.3 ([90dece7](https://github.com/dkarter/cookie_monster/commit/90dece7d71bf009e81425c2d53e29110b5bc9b69))

## [1.1.2](https://github.com/dkarter/cookie_monster/compare/v1.1.1...v1.1.2) (2023-10-15)


### Bug Fixes

* automatically publish docs with hex package ([af3c87d](https://github.com/dkarter/cookie_monster/commit/af3c87ddf943eb2efbc31eb7dba1bece1479cc4b))

## [1.1.1](https://github.com/dkarter/cookie_monster/compare/v1.1.0...v1.1.1) (2023-10-15)


### Bug Fixes

* support dashes in expiration format RFC1123 ([#10](https://github.com/dkarter/cookie_monster/issues/10)) ([81e081a](https://github.com/dkarter/cookie_monster/commit/81e081ab5b45a7da866b02436e90aea11668c83b))

## [1.1.0](https://github.com/dkarter/cookie_monster/compare/v1.0.0...v1.1.0) (2023-10-15)


### Features

* add support for all valid expiration datetime formats ([#8](https://github.com/dkarter/cookie_monster/issues/8)) ([d0c17f7](https://github.com/dkarter/cookie_monster/commit/d0c17f7cbf6fd92caf234f9807be0e81dd39ee4a))

## 1.0.0 (2023-10-15)


### Bug Fixes

* failing test due to Elixir version upgrade ([532852b](https://github.com/dkarter/cookie_monster/commit/532852b3cd65b5687f8efe5fa9a1d4114a1a4999))
* return ArgumentError from `encode!` or `decode!` ([4f2d460](https://github.com/dkarter/cookie_monster/commit/4f2d46010544adf069aa0ee7904de14284dad3cd))
* use of deprecated day_of_week/3 ([11812e9](https://github.com/dkarter/cookie_monster/commit/11812e9e8b8a3ed92b4ce6dc8f13bba7cf4f2d84))
