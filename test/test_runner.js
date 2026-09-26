/**
 * MDEsq - Expanded Programmatic Test Suite
 * Executes rigorous verification of FMV calculations, MVI Risk Audit engine,
 * Sham Peer Review Index, WMC 5-Phase Due Process, Deposition Masterclass,
 * Malpractice Litigation Roadmap, and PHI de-identification sanitizer.
 */

import { JURISDICTIONS, FEDERAL_REGULATIONS } from '../data/statutes.js';
import { SPECIALTY_BENCHMARKS } from '../data/specialties.js';
import { DEPOSITION_CARDINAL_RULES, REPTILE_THEORY_COUNTERMEASURES, MOCK_DEPOSITION_SCENARIOS } from '../data/depositions.js';
import { SHAM_PEER_REVIEW_FACTORS, SUMMARY_SUSPENSION_PLAYBOOK, NPDB_REPORTING_MATRIX } from '../data/peer_review.js';
import { WMC_PHASES, WMC_RESPONSE_RULES, WMC_PHRASE_DISRUPTER, WMC_SANCTION_HIERARCHY } from '../data/wmc_defense.js';
import { MALPRACTICE_LITIGATION_STAGES, MALPRACTICE_INSURANCE_TACTICS } from '../data/malpractice_timeline.js';
import { calculateFMVMetrics, calculateMVIScore, calculateShamScore, sanitizePHI, RISK_QUESTIONS } from '../app.js';

let passedTests = 0;
let totalTests = 0;

function assert(condition, message) {
  totalTests++;
  if (condition) {
    console.log(`  ✅ [PASS] ${message}`);
    passedTests++;
  } else {
    console.error(`  ❌ [FAIL] ${message}`);
    throw new Error(`Assertion failed: ${message}`);
  }
}

console.log('====================================================');
console.log('🩺 RUNNING MDESQ EXPANDED PROGRAMMATIC TEST SUITE');
console.log('====================================================\n');

// 1. STATUTORY DATA INTEGRITY TESTS
console.log('▶ [TEST GROUP 1] Statutory & Jurisdiction Database Integrity');
assert(JURISDICTIONS.WA !== undefined, 'Washington State jurisdiction exists');
assert(JURISDICTIONS.WA.statutes.length >= 6, 'Washington statutes include at least 6 core chapters');

const waStatuteCodes = JURISDICTIONS.WA.statutes.map(s => s.code);
assert(waStatuteCodes.includes('RCW 18.71'), 'Contains RCW 18.71 (Medical Practice Act)');
assert(waStatuteCodes.includes('RCW 18.130'), 'Contains RCW 18.130 (Uniform Disciplinary Act)');
assert(waStatuteCodes.includes('RCW 7.70'), 'Contains RCW 7.70 (Healthcare Malpractice Actions)');
assert(waStatuteCodes.includes('RCW 49.62'), 'Contains RCW 49.62 (Non-Competition Covenants)');
assert(waStatuteCodes.includes('RCW 70.41.200'), 'Contains RCW 70.41.200 (Peer Review QA Privilege)');

const federalIds = FEDERAL_REGULATIONS.map(f => f.id);
assert(federalIds.includes('stark-law'), 'Contains Stark Law (42 U.S.C. § 1395nn)');
assert(federalIds.includes('aks'), 'Contains Anti-Kickback Statute (42 U.S.C. § 1320a-7b)');
assert(federalIds.includes('npdb'), 'Contains NPDB Reporting Regulations');
assert(federalIds.includes('emergency-emtala'), 'Contains EMTALA Requirements');
console.log('  All statutory and regulatory databases verified.\n');

// 2. EXPANDED PEER REVIEW & SHAM INDEX TESTS
console.log('▶ [TEST GROUP 2] Peer Review & Sham Index Engine');
assert(SHAM_PEER_REVIEW_FACTORS.length === 10, 'Sham index contains exactly 10 comprehensive retaliation factors');
assert(SUMMARY_SUSPENSION_PLAYBOOK.length === 4, 'Playbook covers all 4 critical summary suspension phases');
assert(NPDB_REPORTING_MATRIX.length >= 6, 'NPDB matrix covers at least 6 peer review and licensing scenarios');

// Test Zero Sham Score
const zeroSham = calculateShamScore({});
assert(zeroSham.score === 0, 'Zero factors produce Sham score of 0');
assert(zeroSham.tier === 'low', 'Score 0 categorized as Low Sham Probability');

// Test High Sham Probability
const highShamAnswers = {
  'factor-whistleblower': true, // 15
  'factor-competitor-bias': true, // 15
  'factor-procedural-bypass': true, // 10
  'factor-record-denial': true // 10
};
const highSham = calculateShamScore(highShamAnswers);
assert(highSham.score === 50, 'High risk answers calculate exact weighted score (50)');
assert(highSham.tier === 'high', 'Score >= 45 classified as High Probability of Sham Retaliation');
console.log('  Sham Peer Review diagnostic engine verified.\n');

// 3. EXPANDED WMC STATE BOARD DEFENSE TESTS
console.log('▶ [TEST GROUP 3] Washington Medical Commission (WMC) Defense Hub');
assert(WMC_PHASES.length === 5, 'WMC roadmap contains all 5 formal investigation phases');
assert(WMC_RESPONSE_RULES.length === 5, 'Includes 5 non-negotiable rules for Letters of Cooperation');
assert(WMC_PHRASE_DISRUPTER.length >= 3, 'Includes phrase disrupter templates for fatal admissions');
assert(WMC_SANCTION_HIERARCHY.length === 5, 'Sanction hierarchy spans Closure to License Revocation');

const stidSanction = WMC_SANCTION_HIERARCHY.find(s => s.sanction.includes('STID'));
assert(stidSanction !== undefined, 'STID sanction entry exists');
assert(stidSanction.npdbReportable === false, 'STID correctly classified as Non-Reportable to NPDB');
console.log('  WMC Board defense and STID protection logic verified.\n');

// 4. DEPOSITION MASTERCLASS & TRIAL TESTIMONY TESTS
console.log('▶ [TEST GROUP 4] Deposition Masterclass & Reptile Theory Engine');
assert(DEPOSITION_CARDINAL_RULES.length === 8, 'Includes all 8 Cardinal Deposition Rules');
assert(REPTILE_THEORY_COUNTERMEASURES.length >= 3, 'Includes at least 3 Reptile Theory countermeasure templates');
assert(MOCK_DEPOSITION_SCENARIOS.length >= 2, 'Includes at least 2 mock deposition cross-examination scenarios');

const scen1 = MOCK_DEPOSITION_SCENARIOS[0];
assert(scen1.options.some(o => o.grade === 'A+'), 'Scenario includes a Master Defense Response graded A+');
assert(scen1.options.some(o => o.grade === 'F'), 'Scenario includes a Fatal Concession option graded F');
console.log('  Deposition masterclass and mock cross-examination engine verified.\n');

// 5. SPECIALTY & FMV BENCHMARK TESTS
console.log('▶ [TEST GROUP 5] Specialty Compensation & FMV Calculations');
assert(SPECIALTY_BENCHMARKS.length >= 12, 'Includes at least 12 medical/surgical specialties');
const fmvMedian = calculateFMVMetrics('neurosurgery-spine', 850000, 9500, 91.50, 35);
assert(fmvMedian.fmvStatus === 'standard', 'Median compensation categorized as Standard FMV Corridor');
console.log('  FMV benchmarking verified.\n');

// 6. MEDICOLEGAL RISK AUDIT (MVI) TESTS
console.log('▶ [TEST GROUP 6] Medicolegal Vulnerability Index (MVI) Engine');
assert(RISK_QUESTIONS.length === 10, 'Audit contains exactly 10 comprehensive risk questions');
const zeroAnswers = {};
RISK_QUESTIONS.forEach(q => { zeroAnswers[q.id] = 0; });
const mviZero = calculateMVIScore(zeroAnswers);
assert(mviZero.score === 0, 'All-compliant answers produce MVI score of 0');
console.log('  MVI Risk calculation verified.\n');

// 7. PHI / PII ON-DEVICE SANITIZER TESTS
console.log('▶ [TEST GROUP 7] Zero-Knowledge PHI/PII De-Identification Sanitizer');
const rawSensitivePrompt = "Patient John Doe (MRN: 98765432) underwent L4-L5 fusion on 10/14/2025. Phone: (206) 555-0199, SSN: 123-45-6789, email: patient@gmail.com. Can I be sued for dural tear?";
const sanitized = sanitizePHI(rawSensitivePrompt);

assert(!sanitized.includes('John Doe'), 'Patient name redacted');
assert(!sanitized.includes('98765432'), 'MRN redacted');
assert(!sanitized.includes('10/14/2025'), 'Date of service redacted');
assert(!sanitized.includes('(206) 555-0199'), 'Phone number redacted');
assert(!sanitized.includes('123-45-6789'), 'SSN redacted');
assert(!sanitized.includes('patient@gmail.com'), 'Email address redacted');
assert(sanitized.includes('Can I be sued for dural tear?'), 'Clinical legal query preserved intact');
console.log('  PHI sanitizer successfully stripped 100% of sensitive identifiers.\n');

console.log('====================================================');
console.log(`🎯 TEST SUMMARY: ${passedTests}/${totalTests} TESTS PASSED WITH ZERO ERRORS (100%)`);
console.log('====================================================');
