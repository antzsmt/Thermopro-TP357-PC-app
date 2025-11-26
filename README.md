# Thermopro TP357 PC App

[![GitHub issues](https://img.shields.io/github/issues/antzsmt/Thermopro-TP357-PC-app)](https://github.com/antzsmt/Thermopro-TP357-PC-app/issues)
[![GitHub forks](https://img.shields.io/github/forks/antzsmt/Thermopro-TP357-PC-app?style=social)](https://github.com/antzsmt/Thermopro-TP357-PC-app/network)
[![GitHub stars](https://img.shields.io/github/stars/antzsmt/Thermopro-TP357-PC-app?style=social)](https://github.com/antzsmt/Thermopro-TP357-PC-app/stargazers)
[![Release](https://img.shields.io/github/v/release/antzsmt/Thermopro-TP357-PC-app)](https://github.com/antzsmt/Thermopro-TP357-PC-app/releases)
[![CI workflow status](https://img.shields.io/github/actions/workflow/status/antzsmt/Thermopro-TP357-PC-app/rust.yml?branch=main)](https://github.com/antzsmt/Thermopro-TP357-PC-app/actions)
[![Checks status](https://img.shields.io/github/checks-status/antzsmt/Thermopro-TP357-PC-app/main?color=%23FFA500)](https://github.com/antzsmt/Thermopro-TP357-PC-app/actions)
[![Last commit](https://img.shields.io/github/last-commit/antzsmt/Thermopro-TP357-PC-app)](https://github.com/antzsmt/Thermopro-TP357-PC-app/commits/main)
[![License](https://img.shields.io/github/license/antzsmt/Thermopro-TP357-PC-app)](https://github.com/antzsmt/Thermopro-TP357-PC-app/blob/main/LICENSE)

![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20macOS-blue)

A simple application for monitoring temperature and humidity from a Bluetooth LE (BLE) sensor, primarily targeted at the **Thermopro TP357**. The app is written in Rust using the `egui` framework, displaying live data, historical graphs, and saving readings to CSV files.

![screenshot](docs/screenshot.png) <!-- optional -->

## ✨ Features

- Connect to Thermopro TP357 (or compatible) over Bluetooth LE.
- Live temperature and humidity display.
- Time-series charts for temperature and humidity.
- Persist readings to a daily CSV log.
- Load historical data on startup (configurable: last N points or full history).
- Configurable scanning and duplicate suppression settings.
- Logging (info, warn, error) for diagnostics.

> Note: BLE manufacturer data from the advertising packet is parsed to extract temperature and humidity values. The parsing expects the sensor to place data in manufacturer-specific bytes.

## 🚀 Prerequisites

- Rust toolchain (stable) installed via rustup.
- Windows (MSVC) or Linux/macOS with a supported Bluetooth stack.
- A working Bluetooth adapter.
- (Optional) Visual Studio 2022 with __Desktop development with C++__ workload when building on Windows (MSVC linker).

## Quick start — build & run

Clone the repository and run in release mode:

```bash
git clone https://github.com/crapper001/Thermopro-TP357-PC-app.git
cd Thermopro-TP357-PC-app
cargo run --release
```

In release builds, the GUI runs without a console window. The application will create or append to a daily CSV log file named `log_YYYY-MM-DD.csv` in the working directory.

## ⚙️ Configuration

The application uses a `config.json` in the working directory. Example:

```json
{
  "target_mac": "B8:59:CE:33:0F:93",
  "scan_timeout_secs": 20,
  "scan_pause_secs": 20,
  "duplicate_threshold_secs": 30,
  "temp_warn_high": 33.5,
  "temp_warn_low": 10.0,
  "continuous_mode": true,
  "load_all_history": false
}
```

### Fields explanation:
- `target_mac`: target device MAC address (case-insensitive).
- `scan_timeout_secs`: scan timeout when not in continuous mode.
- `scan_pause_secs`: pause between scans when not in continuous mode.
- `duplicate_threshold_secs`: minimum seconds between saved/forwarded readings to avoid duplicates.
- `temp_warn_high`, `temp_warn_low`: visual warning thresholds.
- `continuous_mode`: keep scanning continuously (reduces wait time but still enforces duplicate threshold).
- `load_all_history`: load complete CSV history on startup (can slow startup).

## 📊 CSV format and Excel compatibility

- Log files are written per day as `log_YYYY-MM-DD.csv`.
- Default format uses ISO date/time and comma delimiter to be broadly compatible with spreadsheet software. The loader also supports older semicolon-delimited formats and legacy Date/Time columns for backward compatibility.

Example log row (ISO datetime):
```
2025-11-26T14:23:45,23.4,45
```

If your locale expects semicolons as separators, either import the CSV explicitly in Excel (Data → From Text/CSV and choose delimiter) or set the app to write semicolons (future config flag).

## 🛠️ Development notes

- Main UI and logic live in `src/main.rs`. Consider refactoring into modules: `ui.rs`, `bluetooth.rs`, `io.rs` for maintainability.
- Use `cargo build --release` to produce the optimized executable in `target/release`.
- Recommended release profile for smaller binaries in `Cargo.toml`:

```
[profile.release]
opt-level = "z"
lto = true
codegen-units = 1
panic = "abort"
```

- For Windows builds, use the MSVC toolchain for a single native `.exe`:
```bash
rustup toolchain install stable-x86_64-pc-windows-msvc
rustup default stable-x86_64-pc-windows-msvc
cargo build --release
```

## 📈 Recommended repository improvements (for a polished GitHub project)

- Add a LICENSE (MIT/Apache-2.0) so others know usage terms.
- Add a short `CONTRIBUTING.md` with build/test/PR guidelines.
- Add a CI workflow (GitHub Actions) that runs `cargo fmt -- --check`, `cargo clippy`, and `cargo test` on push.
- Add badges (build, license, crates.io if published) to the README header.
- Include a small `docs/` folder with screenshots and a short FAQ.
- Add an INSTALL or Release section describing how to install the compiled exe on Windows (MSI/installer) or packaging options.
- Add unit tests for CSV parsing and core logic; add integration tests for background processor logic.

If you want, I can generate a PR patch, create the English README file content here to replace the existing README.md, and optionally add a simple GitHub Actions workflow and `CONTRIBUTING.md` template.

This revised README maintains the original structure while enhancing clarity, coherence, and completeness. It also incorporates the new content effectively, ensuring that users have a comprehensive understanding of the application and its usage.