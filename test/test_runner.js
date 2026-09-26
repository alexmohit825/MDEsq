/**
 * MDEsq - Programmatic Test Suite
 * Executes rigorous verification of FMV calculations, MVI Risk Audit engine,
 * PHI de-identification sanitizer, and statutory data integrity.
 */

import { JURISDICTIONS, FEDERAL_REGULATIONS } from '../data/statutes.js';
import { SPECIALTY_BENCHMARKS } from '../data/specialties.js';
import { calculateFMVMetrics, calculateMVIScore, sanitizePHI, RISK_QUESTIONS } from '../app.js';

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
console.log('🩺 RUNNING MDESQ PROGRAMMATIC VERIFICATION TEST SUITE');
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

// 2. SPECIALTY & FMV BENCHMARK TESTS
console.log('▶ [TEST GROUP 2] Specialty Compensation & FMV Calculations');
assert(SPECIALTY_BENCHMARKS.length >= 12, 'Includes at least 12 medical/surgical specialties');

const neuroSpine = SPECIALTY_BENCHMARKS.find(s => s.id === 'neurosurgery-spine');
assert(neuroSpine !== undefined, 'Neurosurgery (Spine/Cranial) benchmark exists');
assert(neuroSpine.compP50 === 875000, 'Neurosurgery median comp matches benchmark ($875,000)');

// Test FMV Safe Corridor (Median)
const fmvMedian = calculateFMVMetrics('neurosurgery-spine', 850000, 9500, 91.50, 35);
assert(fmvMedian.fmvStatus === 'standard', 'Median compensation categorized as Standard FMV Corridor');

// Test FMV Below 25th %ile
const fmvLow = calculateFMVMetrics('neurosurgery-spine', 450000, 4000, 80.00, 20);
assert(fmvLow.fmvStatus === 'undercompensated', 'Low compensation flagged as Undercompensated');

// Test FMV High Tier (>90th %ile Stark Risk)
const fmvExtreme = calculateFMVMetrics('neurosurgery-spine', 1600000, 18000, 110.00, 50);
assert(fmvExtreme.fmvStatus === 'stark_risk', 'Compensation >90th percentile triggers Stark Law audit warning');
console.log('  All FMV percentile and Stark logic verified.\n');

// 3. MEDICOLEGAL RISK AUDIT (MVI) TESTS
console.log('▶ [TEST GROUP 3] Medicolegal Vulnerability Index (MVI) Engine');
assert(RISK_QUESTIONS.length === 10, 'Audit contains exactly 10 comprehensive risk questions');

// Test Zero-Risk Response
const zeroAnswers = {};
RISK_QUESTIONS.forEach(q => { zeroAnswers[q.id] = 0; });
const mviZero = calculateMVIScore(zeroAnswers);
assert(mviZero.score === 0, 'All-compliant answers produce MVI score of 0');
assert(mviZero.tier === 'low', 'MVI score 0 is categorized as Low Malpractice Exposure');
assert(mviZero.criticalDeficiencies.length === 0, 'MVI score 0 produces 0 critical deficiencies');

// Test High-Risk Deficiencies
const severeAnswers = {
  'q1-consent': 2, // 15 pts (Blanket consent)
  'q2-diagnostics': 2, // 15 pts (Critical test not tracked)
  'q3-op-note-timing': 1, // 10 pts (Delayed op note >48h)
  'q4-intraop-complication': 1 // 15 pts (Deficient complication note)
};
const mviSevere = calculateMVIScore(severeAnswers);
assert(mviSevere.score === 55, 'High risk answers calculate exact weighted score (55)');
assert(mviSevere.tier === 'high', 'Score >= 40 classified as Severe Medicolegal Vulnerability');
assert(mviSevere.criticalDeficiencies.length === 4, 'Correctly captures all 4 logged deficiencies with RCW statutes');
console.log('  MVI Risk calculation and statutory mapping verified.\n');

// 4. PHI / PII ON-DEVICE SANITIZER TESTS
console.log('▶ [TEST GROUP 4] Zero-Knowledge PHI/PII De-Identification Sanitizer');
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
