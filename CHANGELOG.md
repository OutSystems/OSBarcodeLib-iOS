# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
