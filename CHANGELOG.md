## v1.7.0

### Features

- Adds `truncate` filter; [#3](https://github.com/wbotelhos/normalizy/pull/3) by [rafaeldev](https://github.com/rafaeldev)

### Updates

- Adds RuboCop task on the CI;

## v1.6.0

### Fixes

- Fix Money Filter to use the correct default Rails path for Currency and Percentage;

### Updates

- Adds Code Quality;
- Adds Test Coverage;
- Migrates the build to Github Actions;
- Removes Git dependency for the build;

## v1.5.0

### Features

- Filter `date` now supports call object that responds to `beginning_of_day` or `end_of_day`;

## v1.4.0

### Features

- Adds `date` support for `Date` class.

## v1.3.0

### Updates

- Support Rails 6.

## v1.2.0

### Features

- `money` filter now allows negative numbers.

## v1.1.1

### Fixes

- When using `slug` filter the original values were not saved.

## v1.1.0

### Features

- Added `slug` filter with the option to apply the value on other fields.

## v1.0.1

### Fixes

- When `type` options were `cents` and had no decimal on the number, extra decimals were added.

## v1.0.0

### Updates

- `raw` options was dropped since `prepend` already works before type cast;
- Multiple lines of `normalizy` will be evaluated from the bottom to top.

### Features

- `alias` configuration now accepts options;

### Fixes

- Multiple filters were not running together.

## v0.2.0

### Updates

- `number` filter no more make cast automatically.
- `number` now accept `cast` options with a method to be used on cast type;

### Features

- add `date` filter with `format`, `time_zone` and I18n error message support;
- add `money` filter with `cast`, `type` and I18n support;
- add `percent` filter with `cast`, `type` and I18n support.

## v0.1.0

- First release.
