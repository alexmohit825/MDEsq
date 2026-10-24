# MDEsq (Native SwiftUI iOS Application)
**Executive Physician Medicolegal Radar & Rights Defense Folio**

[![iOS 18+](https://img.shields.io/badge/iOS-18%2B-blue?logo=apple)](https://developer.apple.com/swift/)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI%206.0-F05138?logo=swift)](https://developer.apple.com/xcode/swiftui/)
[![Swift Charts](https://img.shields.io/badge/Framework-Swift%20Charts-F58220?logo=apple)](https://developer.apple.com/documentation/charts)
[![PDFKit](https://img.shields.io/badge/Framework-PDFKit-red?logo=adobe)](https://developer.apple.com/documentation/pdfkit)
[![TestFlight CI/CD](https://img.shields.io/badge/CI%2FCD-PC--to--TestFlight-success?logo=githubactions)](https://github.com/alexmohit825/MDEsq/actions)
[![Copyright](https://img.shields.io/badge/Copyright-2026%20A.%20Alex%20Mohit-059669)](app_store_metadata.json)

---

## 🏛️ Executive Summary & ADA-Caliber Craftsmanship
**MDEsq** is an Apple Design Award (ADA) candidate-caliber native iOS application engineered for Dr. A. Alex Mohit and licensed healthcare professionals. Built purely in **SwiftUI (iOS 18+)**, MDEsq provides an editorial **"Legal Folio"** aesthetic with deep on-device document intelligence, native `Swift Charts` distributions, interactive tactile simulators, and Edge AI copilot capabilities powered by Cloudflare Workers and Gemini 3.8 Flash.

---

## 💎 The 4 Pillars of Engineering Craftsmanship

### Pillar I — Editorial "Legal Folio" Design System
- **Tri-Font Architectural Typography**: High-contrast, publication-grade pairing using Apple `New York` (`.serif`) for legal holdings, contractual clauses, and statutory citations; `SF Pro` for crisp executive navigation; and `SF Mono` with `.contentTransition(.numericText())` for financial and statutory metrics.
- **Obsidian & Imperial Gold Palette (`MDEsqTheme`)**: Deep obsidian surfaces (`#0A0F1D`), navy card elevations (`#131B2E`), brushed imperial gold accents (`#C9A84C`), emerald compliance tags (`#10B981`), and crimson risk indicators (`#EF4444`).
- **Tactile Haptic Feedback (`MDEsqHaptics`)**: Specialized sensory patterns distinguishing selection ticks, contract risk warnings, and cadence pulses.

### Pillar II — Real Document Intelligence & Deliverables
- **Native `PDFKit` & Multi-Format Intake**: Direct `.fileImporter` integration allowing physicians to import real PDF, RTF, or text employment contracts with zero external server dependencies.
- **Actual Clause Paragraph & Section Extraction**: Intelligently segments contract text, preserves `[Page X]` and `SECTION / ARTICLE` headers, and pairs the physician's exact extracted contract language side-by-side with statutory redlines.
- **Edge AI Clause Rewriter**: Connects securely to the Cloudflare Worker Edge Proxy (`gemini-3.8-flash`) to generate bespoke, surgical riders for idiosyncratic contract provisions.
- **One-Tap Redline Memorandum (`ShareLink`)**: Generates and exports comprehensive, attorney-ready Track-Changes redline briefs formatted for immediate transmission to hospital counsel.

### Pillar III — Tactile Instruments & Native `Swift Charts`
- **Native `Swift Charts` FMV & Stark Law Distribution**: Visualizes compensation distributions across 13 medical/surgical subspecialties, plotting P25, P50 (median), P75, and P90 Stark Law audit thresholds against the physician's total offered compensation.
- **Unassigned Call Stipend Dilution Calculator**: Audits 24-hour unassigned ED/trauma call shifts to calculate hidden physician subsidies against national specialty medians.
- **Interactive 5-Second Pause Haptic Metronome**: Circular tactile cadence trainer with 1 Hz heartbeat pulses, conditioning surgeons to pause 5 full seconds before answering deposition questions.
- **Interactive 30-Day HCQIA Cliff Calculator**: Dynamic date calculator computing exact Day 14 Abeyance and Day 29 Pre-NPDB deadlines to prevent permanent adverse action reporting.

### Pillar IV — Precedent & Practice Shield
- **Landmark Multi-State Malpractice Precedents**: Controls appellate holdings across WA (RCW 7.70, WPI 105.08, *Keen*, *Davis*, *Mohr*, *Branom*), OR (*Gaston*, *Smith*), CA (*Cobbs*, *Truman*), and NY (*Kambat*, *Orphan*) with 1-tap copyable defensive charting formulas.
- **Washington Medical Commission (WMC) Shield**: 5-phase WMC investigation roadmap, 5 rules for 14-day Letters of Cooperation (RCW 18.130.180), phrase disrupters, and RCW 18.130.172 STID non-disciplinary settlement hierarchy.
- **10-Factor Sham Peer Review Retaliation Index**: Quantifies bad-faith economic hospital retaliation under 42 U.S.C. § 11112.
- **Mock Deposition Simulator**: Graded cross-examination scenarios (`A+` to `F`) counteracting plaintiff Reptile Theory traps and learned treatise ambushes.
- **App Store Review Architecture (Rule 7)**: Native `@Environment(\.requestReview)` milestone hooks and persistent ungated rating banner in Settings.

---

## 📱 Source Code Hierarchy (100% Native Swift)
```
MDEsq/
├── App/
│   └── MDEsqApp.swift                      # iOS 18 entrypoint (.preferredColorScheme(.dark))
├── Models/
│   ├── StatuteModels.swift                 # MDEsqTheme, MDEsqHaptics, PHISanitizer, MDEsqEdgeAIClient, StatutoryDatabase
│   ├── SpecialtyModels.swift               # 13 Subspecialties (P25/P50/P75/P90 comp & wRVUs, call stipends)
│   ├── ContractModels.swift                # 7 Predatory rules, 8-clause sample hospital contract, FlaggedClause
│   ├── PrecedentModels.swift               # 10 Landmark multi-state precedents (WA, OR, CA, NY) & charting directives
│   ├── PeerReviewModels.swift              # 10-Factor Sham Index, 4-Phase HCQIA, NPDB Matrix, WMC Roadmap & STID
│   └── DepositionModels.swift              # 8 Cardinal Rules, Reptile Pivots, Graded Mock Scenarios
├── ViewModels/
│   ├── ContractAnalyzerViewModel.swift     # PDFKit import, paragraph splitter, AI rewrite, Redline Memo
│   ├── PrecedentFinderViewModel.swift      # Semantic search, voice dictation, AI Case Strategy synthesis
│   └── FMVCalculatorViewModel.swift         # Percentile interpolation, call dilution, FMV brief generator
├── Views/
│   ├── MainTabView.swift                   # 5 Tab navigation, Global AI Copilot Sheet, Settings & Statutes
│   ├── ContractAnalyzerView.swift          # Legal Folio UI, Grade Ring, Redline Cards, PDF import
│   ├── PrecedentFinderView.swift           # Case Brief Cards, Voice Dictation, Charting SmartPhrases
│   ├── PeerReviewView.swift                # 30-Day Cliff DatePicker, Sham Gauge, WMC Shield & STID
│   ├── DepositionMasterclassView.swift     # Mock Cross-Exam Simulator, 5s Pause Metronome, Cardinal Rules
│   └── FMVCalculatorView.swift             # Swift Charts visualizer, metric strips, call audit sliders
└── Resources/
    ├── Info.plist                          # Dark mode, file sharing, microphone & speech recognition privacy strings
    └── Assets.xcassets                     # 1024×1024 luxury brushed gold & emerald icon
```

---

## 🚀 PC-to-TestFlight Cloud Pipeline (Rule 4)
The `.github/workflows/testflight.yml` workflow compiles, packages, and signs native `.ipa` binaries directly via GitHub Actions:
- **Runner**: `macos-15` (Xcode 16 / iOS 18+)
- **Bundle ID**: `com.dramohit.mdesq`
- **Team ID**: `523MJL63MC`
- **Key ID**: `38F6WA87DU`
- **Issuer ID**: `73c7355a-beef-4d79-919d-c3d7dec7747a`

---

## 🔒 Privacy & Compliance
- **On-Device Regex PHI Sanitization**: Scrubbed locally before any edge AI inference.
- **Zero API Key Exposure**: Gemini 3.8 Flash calls route via Cloudflare Worker encrypted secrets.
- **Encryption Compliance**: `ITSAppUsesNonExemptEncryption = false`.
- **Copyright**: © 2026 A. Alex Mohit. All rights reserved.
