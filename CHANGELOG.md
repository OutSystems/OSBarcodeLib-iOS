# [2.2.0](https://github.com/OutSystems/OSBarcodeLib-iOS/compare/2.1.1...2.2.0) (2026-07-03)


### Bug Fixes

* use Xcode 16 instead of 26 ([#41](https://github.com/OutSystems/OSBarcodeLib-iOS/issues/41)) ([bd584f0](https://github.com/OutSystems/OSBarcodeLib-iOS/commit/bd584f0dc3cba255ae1efe66a069bad69866df92))


### Features

* add accessibility labels to torch and cancel buttons ([#45](https://github.com/OutSystems/OSBarcodeLib-iOS/issues/45)) ([3661cfc](https://github.com/OutSystems/OSBarcodeLib-iOS/commit/3661cfcdf5840a2f797fabeda7c413a326906049)), closes [#44](https://github.com/OutSystems/OSBarcodeLib-iOS/issues/44)

## [2.1.1](https://github.com/OutSystems/OSBarcodeLib-iOS/compare/2.1.0...2.1.1) (2026-02-06)


### Bug Fixes

* **ios:** bundle resources into Swift Package  ([#39](https://github.com/OutSystems/OSBarcodeLib-iOS/issues/39)) ([4a3d137](https://github.com/OutSystems/OSBarcodeLib-iOS/commit/4a3d137795a55b2c2b4fdfe16ad562a36dfd6081))

## 2.1.0

### Features

- Add support for Swift Package Manager (SPM) compatibility. [RMET-4320](https://outsystemsrd.atlassian.net/browse/RMET-4320).

## 2.0.1

- Fix ambiguity between UPC-A and EAN-13 when hint is provided.

## 2.0.0

**BREAKING CHANGE**: The signature of `scanBarcode` has been updated, both input and output.

- Add **hint** parameter to scan for specific barcode formats
- Return the format of the scanned code inside the scan result.

## 1.1.3
- Increase scanning area (https://outsystemsrd.atlassian.net/browse/RMET-3683).

## 1.1.2
- Adds check to scan result confidence value (https://outsystemsrd.atlassian.net/browse/RMET-3374).

## 1.1.1

### Fixes
- Fix pod publish pipeline (https://outsystemsrd.atlassian.net/browse/RMET-3586).
- Fix upside down video capture stream (https://outsystemsrd.atlassian.net/browse/RMET-3585).

## 1.1.0

### Chores
- Update `github_actions.yml` file steps versions (https://outsystemsrd.atlassian.net/browse/RMET-2568).
- Set up the repo to release on CocoaPods (https://outsystemsrd.atlassian.net/browse/RMET-3301).

### Features
- Add zooming out feature (https://outsystemsrd.atlassian.net/browse/RMET-2986).
- Add zooming in feature (https://outsystemsrd.atlassian.net/browse/RMET-2986).

## 1.0.0

### Features
- Implement iPad user interface (https://outsystemsrd.atlassian.net/browse/RMET-2911).
- Implement iPhone user interface (https://outsystemsrd.atlassian.net/browse/RMET-2771).
- Add Scan Orientation Selection feature (https://outsystemsrd.atlassian.net/browse/RMET-2753).
- Add Camera Selection feature (https://outsystemsrd.atlassian.net/browse/RMET-2754).
- Add Scan Button feature (https://outsystemsrd.atlassian.net/browse/RMET-2752).
- Add Scan Instruction text feature (https://outsystemsrd.atlassian.net/browse/RMET-2751).
- Add Torch Button feature (https://outsystemsrd.atlassian.net/browse/RMET-2749).
- Implement the Scan Barcode feature (https://outsystemsrd.atlassian.net/browse/RMET-2748).
