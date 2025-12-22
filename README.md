# Windows DevOps Challenge

## Description

This repository contains PowerShell-based automation for building, testing, running, and cleaning the .NET project(s) under `app/src/` (for example `App.Api` and `App.Test`). The `App.Api` project is built and published as a Windows service that hosts a Web API. The CI workflow (see `dotnet.yml`) handles setup and tools, such as installing the required .NET SDK

---

## Usage 🔧

All commands below use the scripts in the `build/` directory. Run them from the repository root with PowerShell (PowerShell 7+ recommended):

- Build a project:

  ```powershell
  pwsh .\build\build.ps1 -Configuration Release -ProjectName App.Api/app.csproj 
  ```

- Run unit tests for a project:

  ```powershell
  pwsh .\build\test.ps1 -Configuration Release -ProjectName App.Test/App.Test.csproj
  ```

- Install and start the Windows service (from published output):

  ```powershell
  pwsh .\build\run.ps1 -ServiceFile app.exe
  ```

- Run smoke tests (Pester):

  ```powershell
  Invoke-Pester .\build\Smoke.Tests.ps1 -OutputFile logs/pester.xml -OutputFormat NUnitXml
  ```

- Cleanup (stop/remove service and clean workspace):

  ```powershell
  pwsh .\build\cleanup.ps1
  ```
---

## Improvements & Known Issues

**Current limitation / Improvement:** the current `build.ps1` and `test.ps1` scripts require a single `-ProjectName` to be specified and do not automatically discover or iterate over multiple projects. Improvement would be that `build.ps1` and `test.ps1` discover all project files in the repository and build each one by one.

---

## Assumptions

- I assumes that the .NET SDK (`dotnet`) version 8.0 is installed.
- Pester (for running smoke tests) is installed and available for `Invoke-Pester`.
---