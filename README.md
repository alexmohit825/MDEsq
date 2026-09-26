# MDEsq: Physician Legal Radar ⚖️🩺

> **The Elite Pocket Medicolegal, Contract Negotiation & State Board Defense Platform for Physicians & Surgeons.**

---

## 📖 Overview

**MDEsq** equips surgeons and physicians with real-time legal intelligence to counter the information asymmetry typically weaponized by hospital legal departments, health system administrators, and malpractice plaintiff attorneys.

Built with a **Washington State–first** statutory foundation (RCW / WAC / WMC) and extensible across all 50 states, MDEsq combines deterministic healthcare law analytics with cutting-edge Edge AI.

---

## 🚀 Core Functional Modules

### 1. 💰 Physician Contract & FMV Negotiation Engine
* **Fair Market Value (FMV) & Stark Law (42 U.S.C. § 1395nn)**: Dynamic commercial reasonableness evaluation based on national MGMA/AMGA benchmark curves (25th, 50th, 75th, 90th percentiles) across surgical and medical specialties.
* **wRVU Conversion Modeling**: Base salary vs. $/wRVU threshold conversion calculations and 24-hour call stipend valuation.
* **Contract Red Flag Scanner**: Real-time auditing of:
  * Restrictive covenants against Washington's **RCW 49.62** (statutory salary threshold, 18-month presumption, moonlighting protections, mandatory attorney fees).
  * Malpractice tail insurance allocation (Claims-made vs. Occurrence vs. 50/50 employer split on termination without cause).
  * Without-cause termination notice windows (targeting 90–120 days).
  * Unilateral medical staff bylaw / policy modification traps.

### 2. 🛡️ Medicolegal Negligence & Standard of Care Audit (MVI)
* Interactive **10-Point Clinical Vulnerability Engine** scoring documentation exposure across high-risk surgical vectors:
  1. Material risk & non-operative alternative disclosure (**RCW 7.70.050**)
  2. Closed-loop critical test & pathology tracking (*Keogan v. Holy Family Hosp.*)
  3. Operative report dictation timing & immediate PACU charting (**WAC 246-919**)
  4. Intraoperative complication recognition & objective technical repair charting
  5. Foreign body & surgical count discrepancy resolution (Res Ipsa Loquitur)
  6. Post-op handoff & objective neurological escalation parameters
  7. Written discharge red flags & emergency safety-netting
  8. Contemporaneous after-hours telephone encounter charting
  9. AMA refusal of care & life-threat consequence documentation
  10. Peer review & incident report segregation (**RCW 70.41.200 QA privilege**)
* Outputs the **Medicolegal Vulnerability Index (MVI)** with prioritized defensive corrective actions.

### 3. 🏛️ State Medical Board Due Process & License Defense Shield
* **Washington Medical Commission (WMC)** 4-phase investigation roadmap:
  * **Phase 1**: Notice of Complaint & Letter of Cooperation (Critical 14–30 day window; record preservation rules).
  * **Phase 2**: Case Management Committee (CMC) threshold review.
  * **Phase 3**: Stipulation to Informal Disposition (STID - **RCW 18.130.172** non-disciplinary shield).
  * **Phase 4**: Formal Charges & OAH Administrative Hearing (*Clear and Convincing Evidence* standard).
* **NPDB Mandatory Reporting Matrix**: Definitive classification of reportable vs. non-reportable peer review and licensure actions.

### 4. 📚 Statutory & Landmark Case Law Explorer
* Searchable repository of Washington statutes (**RCW 18.71, RCW 18.130, RCW 7.70, RCW 49.62, RCW 70.41.200**), administrative codes (**WAC 246-919**), and landmark Washington Supreme Court tort decisions (*Sofie v. Fibreboard Corp.*, *Miller v. Kennedy*).

### 5. ✨ MDEsq AI Medicolegal Copilot
* On-Device **Zero-Knowledge PHI/PII Sanitizer** automatically redacting MRNs, patient names, dates, phone numbers, and emails prior to cloud transmission.
* Serverless Edge proxy architecture (**Cloudflare Pages + Workers**) with zero API key exposure in client-side bundles.

---

## 🔒 Security, HIPAA & Zero-PII Guarantee

MDEsq executes client-side regex sanitization on all user queries prior to API transmission. No patient health information (PHI) is ever transmitted, indexed, or stored.

---

## 🧪 Verification & Testing

Programmatic verification test suite executed via:
```bash
npm test
```
* **Status**: 31 / 31 Unit Tests Passing (100% Coverage on FMV math, MVI scoring, PHI redaction, and statutory lookups).

---

## ⚖️ Legal Disclaimer

*MDEsq is an educational and analytical reference tool for licensed healthcare professionals. It does not establish an attorney-client relationship or provide formal legal representation. Always consult retained healthcare legal counsel for binding legal decisions.*

---

© 2026 A. Alex Mohit. All rights reserved.
