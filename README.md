# scRIIPS

A personal collection of input-automation and accessibility tools, mostly built for one-handed / limited-input play on a handful of PC games, plus a few utility scripts that live in the same folder.

This repository is currently organized as a wrapper around the active project under `scRIIPS/scRIIPS/`. Most of the working scripts, configs, profiles, and compiled builds are stored there rather than at the repository root.

## Current repository structure

```text
script-kit/
├── README.md
├── scRIIPS/
│   └── scRIIPS/
│       ├── Combo_ReMapper_9_5.ahk
│       ├── Combo_ReMapper_9_5.exe
│       ├── OSK_Maker.ahk
│       ├── README.md
│       ├── combo_config.ini
│       ├── combo_remapper_README.md
│       ├── profiles/
│       ├── nmh_profiles/
│       ├── DIS/
│       ├── pop/
│       ├── unfinisd/
│       ├── .vs/
│       ├── layout.osk
│       ├── math_osk  5.ahk
│       ├── krita osk  5.ahk
│       ├── rpcs3_qte_assist_README.md
│       └── ...
│
└── (top-level repo files are minimal; the active project lives under the nested scRIIPS folder)
```

## What is active

The real working project is:

- `scRIIPS/scRIIPS/`

That folder contains the current AutoHotkey/AutoIt scripts, saved profiles, support data, legacy builds, and documentation for the active project set.

## Main folders inside the active project

- `scRIIPS/scRIIPS/profiles/` — saved keybind / combo profile files
- `scRIIPS/scRIIPS/nmh_profiles/` — NMH-specific profile presets
- `scRIIPS/scRIIPS/pop/` — Popotan-related translation / image patch assets
- `scRIIPS/scRIIPS/DIS/` — documentation and game-specific helper files
- `scRIIPS/scRIIPS/unfinisd/` — older / unfinished script versions and experiments
- `scRIIPS/scRIIPS/.vs/` — editor metadata, not part of the gameplay tool itself

## A few notable tools in the project

- Combo ReMapper — key and mouse remapping / combo scripts
- OSK Maker — custom on-screen keyboard designer
- NMH accessibility / profile tools
- Popotan translation support files
- Legacy builds kept in `unfinisd/old/` for reference

## Quick start

If you are looking for the current active build, start here:

- `scRIIPS/scRIIPS/README.md`
- `scRIIPS/scRIIPS/Combo_ReMapper_9_5.ahk`
- `scRIIPS/scRIIPS/OSK_Maker.ahk`

Many scripts are Windows-specific and rely on AutoHotkey / AutoIt. If you want to inspect behavior before running them, open the `.ahk` / `.au3` source files directly in a text editor.

## Notes

- This repository is primarily a personal utility archive and scripting workspace.
- Some files are compiled `.exe` builds, some are source scripts, and some are historical or unfinished experiments.
- The nested `scRIIPS/scRIIPS` folder is the best place to start when looking for the active toolchain.

## License / sharing

These are personal accessibility tools and are shared freely for modification, reuse, or redistribution within the same spirit as the rest of this collection.
