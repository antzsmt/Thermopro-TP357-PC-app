# Contributing to Thermopro TP357 PC App

Thank you for your interest in contributing. This document explains how to get the project building locally, run tests, follow the code style, and submit changes.

## Code of conduct
Please be respectful and constructive. Report unacceptable behavior by opening an issue or contacting the maintainers.

## Getting started
1. Fork the repository and clone your fork:

```bash
git clone https://github.com/<your-username>/Thermopro-TP357-PC-app.git
cd Thermopro-TP357-PC-app
```

2. Install Rust (use rustup). Recommended toolchain: `stable`.

3. Build the project:

```bash
cargo build
```

## Branching and PR workflow
- Create a feature branch from `main`: `git checkout -b feature/short-description`.
- Keep changes focused and add tests where applicable.
- Rebase or merge from `main` to keep your branch up to date.
- Open a pull request against `main` with a clear description of the change.

## Tests
- Unit tests: `cargo test`.
- Run the full test suite locally before creating a PR.

## Formatting and linting
- Run `cargo fmt` to format code. CI checks formatting with `cargo fmt -- --check`.
- Run `cargo clippy -- -D warnings` and fix reported warnings.

Recommended commands:

```bash
# format
cargo fmt
# lint (clippy)
cargo clippy -- -D warnings
# tests
cargo test
```

## Commit messages
Use clear, imperative commit messages. Example:

```
feat(ui): add settings panel
fix(csv): handle semicolon delimiter fallback
```

## CI and checks
The repository includes a GitHub Actions workflow at `.github/workflows/rust.yml` that runs on push and pull requests. The workflow checks formatting, linting, tests and builds the release binary.

## Submitting changes
- Push your branch to your fork and open a PR.
- Respond to review comments. Keep PRs small and focused.

## Reporting issues
- Open an issue with a clear title and steps to reproduce. Attach logs/screenshots when useful.

## License
By contributing you agree that your contributions will be licensed under the project license (see `LICENSE`).

## Visual Studio: open solution and build (Windows)

If you prefer to use Visual Studio to run and build the project on Windows, the repository includes a simple solution and a Makefile-style project that calls the provided PowerShell helper (`build.ps1`). Before using Visual Studio, ensure the Rust MSVC toolchain and Visual Studio **Desktop development with C++** workload are installed.

Quick steps:
1. Open `Thermopro-TP357-PC-app.sln` in Visual Studio (**File > Open > Project/Solution**).
2. In Visual Studio select the configuration (Debug / Release) and platform (x64) in the toolbar.
3. Build:
   - Build the project (right-click project → **Build**), or
   - Press F5 / Debug > Start Debugging to run (the project runs the `build.ps1` script which executes `cargo build`).
4. The script invokes `VsDevCmd.bat` to set up the MSVC environment then runs `cargo build --release`. Artifacts are produced in `target\release` (Release) or `target\debug` (Debug).
5. If Visual Studio cannot find developer tools, open a Developer PowerShell (Tools > Command Line > Developer PowerShell) and run: