# Privacy Policy for MDEsq

**Effective Date:** January 1, 2026  
**Developer:** A. Alex Mohit (`mohalex@gmail.com`)

## 1. Zero-Knowledge On-Device Processing
MDEsq is engineered with a strict **Zero-Knowledge Architecture**. All core functionalities, including:
- Physician contract document parsing
- Medicolegal precedent matching
- Sham peer review diagnostics
- Fair Market Value (FMV) compensation math
- Protected Health Information (PHI) de-identification sanitization

execute entirely **on-device** within the iOS application sandbox.

## 2. No Data Collection or Tracking
- MDEsq does **not** collect, store, sell, or transmit any personal identifiable information (PII), patient data, medical records, or uploaded contracts.
- MDEsq does **not** utilize third-party analytics trackers, advertising SDKs, or tracking cookies.

## 3. Speech Recognition & Microphone Permissions
When you utilize voice dictation in the Precedent Finder, audio is processed on-device via Apple's native Speech Recognition API (`SFSpeechRecognizer`). Audio recordings are never stored or transmitted to external servers.

## 4. Third-Party AI Edge Proxy (Optional)
If you elect to use cloud AI Copilot features, all prompts are stripped of patient identifiers (MRNs, names, phone numbers, dates) on-device prior to transmission through an encrypted V8 isolate proxy.

## 5. Contact
For privacy questions or inquiries:
**A. Alex Mohit**  
Email: `mohalex@gmail.com`  
Website: `https://github.com/alexmohit825/MDEsq`
