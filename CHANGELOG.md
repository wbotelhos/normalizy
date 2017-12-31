## v1.1.1

- Fixes:
  - When use `slug` filter the original values was not saved.

## v1.1.0

- Features:
  - Added `slug` filter with option to apply the value on other field.

## v1.0.1

- Fixes:
  - When `type` options was `cents` and had no decimal on number, extra decimal were added.

## v1.0.0

- Changes:
  - `raw` options was dropped since `prepend` already works before type cast;
  - Multiple lines of `normalizy` will be evaluated from the bottom to top.

- Features:
  - `alias` configuration now accepts options;

- Fixes:
  - Multiple filters were not running together.

## v0.2.0

- Changes:
  - `number` filter no more make cast automatically.
  - `number` now accept `cast` options with method to be used on cast type;

- Features:
  - add `date` filter with `format`, `time_zone` and I18n error message support;
  - add `money` filter with `cast`, `type` and I18n support;
  - add `percent` filter with `cast`, `type` and I18n support.

## v0.1.0

- First release.
