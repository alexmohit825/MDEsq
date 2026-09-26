/**
 * MDEsq - Main Application Controller
 * High-performance, zero-dependency ES Module
 * Light Executive Theme & Expanded Peer Review / WMC Modules
 */

import { JURISDICTIONS, FEDERAL_REGULATIONS } from './data/statutes.js';
import { SPECIALTY_BENCHMARKS } from './data/specialties.js';
import { DEPOSITION_CARDINAL_RULES, REPTILE_THEORY_COUNTERMEASURES, MOCK_DEPOSITION_SCENARIOS } from './data/depositions.js';
import { SHAM_PEER_REVIEW_FACTORS, SUMMARY_SUSPENSION_PLAYBOOK, NPDB_REPORTING_MATRIX } from './data/peer_review.js';
import { WMC_PHASES, WMC_RESPONSE_RULES, WMC_PHRASE_DISRUPTER, WMC_SANCTION_HIERARCHY } from './data/wmc_defense.js';
import { MALPRACTICE_LITIGATION_STAGES, MALPRACTICE_INSURANCE_TACTICS } from './data/malpractice_timeline.js';

// Application State
const state = {
  currentJurisdiction: 'WA',
  currentTab: 'tab-peer-review',
  selectedSpecialtyId: 'neurosurgery-spine',
  auditAnswers: {},
  shamAnswers: {},
  apiKey: (typeof localStorage !== 'undefined' && localStorage.getItem('mdesq_gemini_key')) || '',
  currentMockDepIndex: 0,
  fmvChart: null,
  chatHistory: []
};

// 10-Point Medicolegal & Standard of Care Audit Questionnaire Data
export const RISK_QUESTIONS = [
  {
    id: 'q1-consent',
    category: 'Informed Consent',
    statute: 'RCW 7.70.050',
    weight: 15,
    title: '1. Material Risks & Non-Surgical Alternative Disclosure',
    question: 'Did your informed consent documentation explicitly articulate procedure-specific material risks (e.g., nerve root injury, dural tear, infection, revision) and viable non-operative alternatives (physical therapy, injections, observation)?',
    options: [
      { text: 'Yes — Detailed, procedure-specific risks and non-operative alternatives documented and signed contemporaneously with patient discussion.', riskScore: 0, compliant: true },
      { text: 'Partial — Standard pre-printed hospital consent signed, but minimal specific documentation in physician clinical note.', riskScore: 8, compliant: false },
      { text: 'No — Generic blanket consent form with no documentation of alternative discussion.', riskScore: 15, compliant: false }
    ]
  },
  {
    id: 'q2-diagnostics',
    category: 'Diagnostic Tracking',
    statute: 'Keogan v. Holy Family Hosp. (WA 1980)',
    weight: 15,
    title: '2. Closed-Loop Critical Diagnostic & Pathology Tracking',
    question: 'Was there a documented closed-loop tracking system verifying that abnormal imaging/pathology results were communicated directly to the patient and acted upon?',
    options: [
      { text: 'Yes — Result reviewed, documented discussion with patient, and clear follow-up action plan charted.', riskScore: 0, compliant: true },
      { text: 'Partial — Result was acknowledged in EMR inbox, but patient notification/action plan was not explicitly charted.', riskScore: 8, compliant: false },
      { text: 'No / Uncertain — Critical test ordered without documented follow-up confirmation or chart closure.', riskScore: 15, compliant: false }
    ]
  },
  {
    id: 'q3-op-note-timing',
    category: 'Operative Documentation',
    statute: 'WAC 246-919-601 / Hospital Bylaws',
    weight: 10,
    title: '3. Operative & Procedural Note Dictation Timing',
    question: 'Was a formal operative note dictated/authored immediately or within 24 hours of surgery, accompanied by a contemporaneous immediate brief post-op note?',
    options: [
      { text: 'Yes — Immediate brief note charted in PACU, and full formal operative report dictated within 24 hours.', riskScore: 0, compliant: true },
      { text: 'Delayed — Formal operative report authored >48 hours post-procedure or after complication became clinically apparent.', riskScore: 10, compliant: false }
    ]
  },
  {
    id: 'q4-intraop-complication',
    category: 'Surgical Complications',
    statute: 'RCW 7.70.040 (Standard of Care)',
    weight: 15,
    title: '4. Intraoperative Complications & Technical Departure Rationale',
    question: 'If an intraoperative complication or anatomical variant occurred (e.g. vascular injury, durotomy, abnormal anatomy), was the discovery, corrective step, and clinical rationale documented objectively without defensive language?',
    options: [
      { text: 'Yes / Not Applicable — Objective recognition, repair/hemostasis technique, and stable outcome documented clearly.', riskScore: 0, compliant: true },
      { text: 'Deficient — Complication occurred but minimal technical details recorded, or charting contains retroactive edits.', riskScore: 15, compliant: false }
    ]
  },
  {
    id: 'q5-counts-foreign-body',
    category: 'Surgical Safety',
    statute: 'Res Ipsa Loquitur Doctrine / RCW 7.70',
    weight: 10,
    title: '5. Sharps, Sponge & Implant Verification Protocol',
    question: 'Were correct surgical counts confirmed, verified with circulating nurse, and intraoperative radiographic confirmation documented if count discrepancies occurred?',
    options: [
      { text: 'Yes — Dual verified counts charted, all implants/hardware accounted for.', riskScore: 0, compliant: true },
      { text: 'Discrepancy Unresolved — Count discrepancy noted without documented intraoperative X-ray or surgical explorer resolution.', riskScore: 10, compliant: false }
    ]
  },
  {
    id: 'q6-handoff-pacu',
    category: 'Handoff Safety',
    statute: 'Standard of Care (RCW 7.70.040)',
    weight: 10,
    title: '6. Post-Operative Handoff & Neurologic/Vascular Monitoring Orders',
    question: 'Were explicit, patient-specific PACU monitoring orders and physician-to-physician / physician-to-nurse handoff documented with objective baseline neurological/vital parameters?',
    options: [
      { text: 'Yes — Standardized SBAR handoff documented with specific parameters for surgeon notification.', riskScore: 0, compliant: true },
      { text: 'Generic — Standard uncustomized post-op order set without specific neuro/vascular escalation triggers.', riskScore: 10, compliant: false }
    ]
  },
  {
    id: 'q7-discharge-instructions',
    category: 'Discharge & Safety Netting',
    statute: 'RCW 7.70.040',
    weight: 10,
    title: '7. Written Discharge Red Flags & Emergency Safety-Netting',
    question: 'Did discharge instructions provide clear, written, symptom-specific red flags (e.g., progressive neurological deficit, fever >101.5°F, acute wound drainage, intractable pain) with exact instructions to report immediately to the ED?',
    options: [
      { text: 'Yes — Explicit written red-flag symptoms with 24/7 on-call contact and ED presentation instructions provided.', riskScore: 0, compliant: true },
      { text: 'Vague / Incomplete — Generic "call if problems" or routine hospital discharge sheet without procedure-specific warnings.', riskScore: 10, compliant: false }
    ]
  },
  {
    id: 'q8-after-hours-calls',
    category: 'Telephone / After-Hours Advice',
    statute: 'WAC 246-919-601',
    weight: 5,
    title: '8. Contemporaneous After-Hours Clinical Call Documentation',
    question: 'Were all after-hours patient phone calls, medication refill requests, or family inquiries logged contemporaneously into the electronic medical record?',
    options: [
      { text: 'Yes — Timestamped telephone encounters charted within 24 hours.', riskScore: 0, compliant: true },
      { text: 'Uncharted / Informal — Verbal advice given over telephone without contemporaneous chart entry.', riskScore: 5, compliant: false }
    ]
  },
  {
    id: 'q9-ama-noncompliance',
    category: 'Patient Non-Compliance',
    statute: 'Contributory Fault (RCW 4.22)',
    weight: 5,
    title: '9. Documentation of Patient Non-Adherence or Refusal of Care',
    question: 'If the patient declined recommended investigations, therapy, or left Against Medical Advice (AMA), were specific clinical consequences and risks of death/disability explained and documented?',
    options: [
      { text: 'Yes / Not Applicable — Specific risks explained, patient capacity assessed, and signed refusal/detailed note recorded.', riskScore: 0, compliant: true },
      { text: 'Deficient — Patient missed critical follow-up or declined care without documented outreach or consequence discussion.', riskScore: 5, compliant: false }
    ]
  },
  {
    id: 'q10-peer-review-separation',
    category: 'Privilege & Peer Review',
    statute: 'RCW 70.41.200 (QA Privilege)',
    weight: 5,
    title: '10. Strict Separation of Peer Review / Incident Reports from EMR',
    question: 'Was incident reporting or internal QA discussion maintained strictly through hospital risk management channels rather than referenced or debated within the patient’s permanent clinical chart?',
    options: [
      { text: 'Yes — Clinical chart contains purely factual medical descriptions; no mention of incident reports or peer review meetings.', riskScore: 0, compliant: true },
      { text: 'Compromised Privilege — Clinical chart notes mention "incident report filed" or critique other staff members, waiving statutory privilege.', riskScore: 5, compliant: false }
    ]
  }
];

// Zero-PII Sanitizer to scrub patient identifiers before AI processing
export function sanitizePHI(rawText) {
  if (!rawText) return '';
  return rawText
    .replace(/\b(MRN|mrn|ID|id|record\s*#?)\s*[:#]?\s*\d{4,12}\b/gi, '[MRN-REDACTED]')
    .replace(/\b\d{3}[-]?\d{2}[-]?\d{4}\b/g, '[SSN-REDACTED]')
    .replace(/\b(?:\+?1[-.\s]?)?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}\b/g, '[PHONE-REDACTED]')
    .replace(/\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b/g, '[EMAIL-REDACTED]')
    .replace(/\b\d{1,2}[\/\.-]\d{1,2}[\/\.-]\d{2,4}\b/g, '[DATE-REDACTED]')
    .replace(/\b(Patient|pt|Mr\.|Ms\.|Mrs\.)\s+([A-Z][a-z]+)(\s+[A-Z][a-z]+)?\b/g, '[PATIENT-NAME-REDACTED]');
}

// Compensation & FMV Calculator Logic
export function calculateFMVMetrics(specialtyId, baseSalary, targetWrvus, convFactor, callDays) {
  const spec = SPECIALTY_BENCHMARKS.find(s => s.id === specialtyId) || SPECIALTY_BENCHMARKS[0];
  const calculatedProductionComp = targetWrvus * convFactor;
  const totalEstimatedComp = Math.max(baseSalary, calculatedProductionComp);

  let fmvStatus = 'standard';
  let statusTitle = 'Standard FMV Corridor';
  let statusClass = 'emerald';
  let statusDesc = '';

  if (totalEstimatedComp < spec.compP25) {
    fmvStatus = 'undercompensated';
    statusTitle = 'Below 25th Percentile (Severe Undercompensation)';
    statusClass = 'amber';
    statusDesc = `Your compensation package ($${totalEstimatedComp.toLocaleString()}) is below the 25th national percentile for ${spec.name} ($${spec.compP25.toLocaleString()}). You have strong leverage to negotiate a higher base salary or increased $/wRVU conversion rate.`;
  } else if (totalEstimatedComp <= spec.compP75) {
    fmvStatus = 'standard';
    statusTitle = 'Safe FMV Corridor (25th–75th Percentile)';
    statusClass = 'emerald';
    statusDesc = `Your compensation package ($${totalEstimatedComp.toLocaleString()}) falls squarely within the nationally accepted Fair Market Value corridor (25th–75th percentile). Presents minimal Stark Law audit risk for hospital employers.`;
  } else if (totalEstimatedComp <= spec.compP90) {
    fmvStatus = 'high_fmv';
    statusTitle = 'Upper FMV Corridor (75th–90th Percentile)';
    statusClass = 'blue';
    statusDesc = `Your compensation package ($${totalEstimatedComp.toLocaleString()}) is in the 75th–90th percentile. Hospital legal counsel may require independent third-party FMV opinion letters to support Stark Law commercial reasonableness, but production-based alignment is defensible.`;
  } else {
    fmvStatus = 'stark_risk';
    statusTitle = 'Stark Law / FMV Regulatory Audit Exposure (>90th Percentile)';
    statusClass = 'rose';
    statusDesc = `Your total cash compensation ($${totalEstimatedComp.toLocaleString()}) exceeds the 90th percentile ($${spec.compP90.toLocaleString()}). Under 42 U.S.C. § 1395nn, this requires rigorous documentation proving extraordinary wRVU productivity or surgical subspecialty regional scarcity to avoid AKS/Stark scrutiny.`;
  }

  return {
    specialty: spec,
    totalEstimatedComp,
    calculatedProductionComp,
    fmvStatus,
    statusTitle,
    statusClass,
    statusDesc
  };
}

// Medicolegal Vulnerability Score Calculator
export function calculateMVIScore(answers) {
  let score = 0;
  const criticalDeficiencies = [];

  RISK_QUESTIONS.forEach(q => {
    const selectedIndex = answers[q.id];
    if (selectedIndex !== undefined && selectedIndex !== null) {
      const selectedOption = q.options[selectedIndex];
      score += selectedOption.riskScore;
      if (selectedOption.riskScore > 0) {
        criticalDeficiencies.push({
          question: q.title,
          category: q.category,
          statute: q.statute,
          riskScore: selectedOption.riskScore,
          selectedText: selectedOption.text
        });
      }
    }
  });

  let tier = 'low';
  let tierLabel = 'Low Malpractice Exposure (Optimal Defense)';
  let tierNarrative = 'Your clinical documentation and handoff protocols reflect rigorous adherence to Washington standard of care (RCW 7.70). High defensive resilience in potential plaintiff cross-examinations.';
  let badgeColor = 'emerald';

  if (score >= 40) {
    tier = 'high';
    tierLabel = 'Severe Medicolegal Vulnerability';
    tierNarrative = 'Multiple high-exposure documentation gaps identified. Significant vulnerability under RCW 7.70 informed consent, test tracking, or operative dictation standards. Immediate chart remediation recommended.';
    badgeColor = 'rose';
  } else if (score >= 15) {
    tier = 'moderate';
    tierLabel = 'Moderate Liability Exposure';
    tierNarrative = 'Identified discrete documentation and handoff vulnerabilities that plaintiff expert witnesses commonly target. Remedying informed consent specificity and tracking loops will significantly mitigate risk.';
    badgeColor = 'amber';
  }

  return {
    score,
    tier,
    tierLabel,
    tierNarrative,
    badgeColor,
    criticalDeficiencies
  };
}

// Sham Peer Review Score Calculator
export function calculateShamScore(selectedFactors) {
  let score = 0;
  SHAM_PEER_REVIEW_FACTORS.forEach(f => {
    if (selectedFactors[f.id]) {
      score += f.weight;
    }
  });

  let tier = 'low';
  let tierLabel = 'Low Sham Probability (Standard Review)';
  let tierNarrative = 'Current factors indicate standard clinical quality assurance review. Maintain factual cooperation and ensure peer review privilege under RCW 70.41.200.';
  let badgeClass = 'emerald';

  if (score >= 45) {
    tier = 'high';
    tierLabel = 'High Probability of Sham / Bad-Faith Retaliation';
    tierNarrative = 'Multiple critical indicators of bad-faith economic retaliation or procedural bypass detected. Do NOT resign privileges. Retain private healthcare counsel immediately and demand an external independent academic review.';
    badgeClass = 'rose';
  } else if (score >= 20) {
    tier = 'moderate';
    tierLabel = 'Moderate Retaliation Concern (Elevated Vigilance)';
    tierNarrative = 'Procedural anomalies detected. Scrutinize committee composition for competitor bias and demand complete unredacted EMR records under Medical Staff Bylaws.';
    badgeClass = 'amber';
  }

  return {
    score,
    tier,
    tierLabel,
    tierNarrative,
    badgeClass
  };
}

// DOM Binding
if (typeof document !== 'undefined') {
  document.addEventListener('DOMContentLoaded', () => {
    if (typeof window !== 'undefined' && window.lucide) {
      window.lucide.createIcons();
    }

    initNavigation();
    initJurisdictionSelector();
    initPeerReviewShield();
    initWMCBoardDefense();
    initDepositionMasterclass();
    initFMVCalculator();
    initRiskAudit();
    initMalpracticeLitigation();
    initStatuteExplorer();
    initAICopilot();
    initSettingsModal();
  });
}

// Navigation Handling
function initNavigation() {
  const tabs = document.querySelectorAll('.nav-tab');
  tabs.forEach(tab => {
    tab.addEventListener('click', () => {
      const targetTabId = tab.getAttribute('data-tab');
      state.currentTab = targetTabId;

      tabs.forEach(t => {
        t.classList.remove('active-tab', 'text-emerald-700', 'bg-emerald-50', 'border-emerald-200');
        t.classList.add('text-slate-600');
      });
      tab.classList.add('active-tab', 'text-emerald-700', 'bg-emerald-50', 'border-emerald-200');
      tab.classList.remove('text-slate-600');

      document.querySelectorAll('.tab-panel').forEach(p => p.classList.add('hidden'));
      const targetPanel = document.getElementById(targetTabId);
      if (targetPanel) {
        targetPanel.classList.remove('hidden');
      }

      if (targetTabId === 'tab-fmv-contracts') {
        setTimeout(updateFMVChart, 50);
      }

      if (typeof window !== 'undefined' && window.lucide) window.lucide.createIcons();
    });
  });
}

// Jurisdiction Selector Handling
function initJurisdictionSelector() {
  const select = document.getElementById('jurisdiction-select');
  if (!select) return;

  select.addEventListener('change', (e) => {
    state.currentJurisdiction = e.target.value;
    updateJurisdictionContext();
  });
}

function updateJurisdictionContext() {
  const jur = JURISDICTIONS[state.currentJurisdiction] || JURISDICTIONS.WA;
  const fmvBadge = document.getElementById('state-badge-fmv');
  if (fmvBadge) fmvBadge.textContent = `${jur.abbr} Mode`;

  const ncTag = document.getElementById('nc-enforceability-tag');
  if (ncTag) {
    ncTag.textContent = jur.nonCompeteStatus.substring(0, 32);
  }

  renderStatutes();
}

// ========================================================
// 1. EXPANDED PEER REVIEW & SUMMARY SUSPENSION SHIELD
// ========================================================
function initPeerReviewShield() {
  renderShamFactors();
  renderSuspensionPlaybook();
  renderNPDBMatrix();
}

function renderShamFactors() {
  const container = document.getElementById('sham-factors-container');
  if (!container) return;

  container.innerHTML = SHAM_PEER_REVIEW_FACTORS.map(f => `
    <label class="flex items-start space-x-3 p-3.5 rounded-2xl bg-slate-50 border border-slate-200 hover:border-blue-400 hover:bg-blue-50/30 cursor-pointer transition text-xs shadow-xs">
      <input type="checkbox" data-factor-id="${f.id}" class="sham-factor-cb mt-1 text-blue-600 focus:ring-blue-500 rounded">
      <div class="space-y-1">
        <span class="font-bold text-slate-900 block">${f.title} (+${f.weight} pts)</span>
        <p class="text-slate-600 leading-relaxed">${f.description}</p>
        <span class="text-[11px] text-blue-700 block font-medium">📋 Key Evidence: ${f.evidenceRequired}</span>
      </div>
    </label>
  `).join('');

  container.addEventListener('change', (e) => {
    if (e.target.classList.contains('sham-factor-cb')) {
      const factorId = e.target.getAttribute('data-factor-id');
      state.shamAnswers[factorId] = e.target.checked;
      updateShamScore();
    }
  });
}

function updateShamScore() {
  const res = calculateShamScore(state.shamAnswers);

  const badge = document.getElementById('sham-score-badge');
  if (badge) {
    badge.textContent = `Score: ${res.score} / 100 (${res.tier.toUpperCase()})`;
    badge.className = `px-3 py-1 rounded-xl bg-${res.badgeClass}-50 text-${res.badgeClass}-800 font-mono font-bold text-xs border border-${res.badgeClass}-200`;
  }

  const pill = document.getElementById('sham-tier-pill');
  if (pill) {
    pill.textContent = res.tierLabel;
    pill.className = `text-[10px] px-2.5 py-0.5 rounded-full font-bold bg-${res.badgeClass}-100 text-${res.badgeClass}-800`;
  }

  const narrative = document.getElementById('sham-tier-narrative');
  if (narrative) narrative.textContent = res.tierNarrative;
}

function renderSuspensionPlaybook() {
  const container = document.getElementById('suspension-playbook-container');
  if (!container) return;

  container.innerHTML = SUMMARY_SUSPENSION_PLAYBOOK.map(p => `
    <div class="p-4 rounded-2xl bg-slate-50 border border-slate-200 space-y-2 hover:border-${p.color}-300 transition shadow-xs">
      <div class="flex items-center justify-between">
        <span class="text-xs font-bold text-slate-900">${p.dayRange}</span>
        <span class="text-[10px] px-2.5 py-0.5 rounded-full bg-${p.color}-100 text-${p.color}-800 font-mono font-bold">${p.phaseTitle}</span>
      </div>
      <ul class="space-y-1.5 pt-1 text-xs text-slate-700">
        ${p.criticalActions.map(action => `
          <li class="flex items-start gap-1.5">
            <span class="text-${p.color}-600 font-bold">•</span>
            <span class="leading-relaxed">${action}</span>
          </li>
        `).join('')}
      </ul>
    </div>
  `).join('');
}

function renderNPDBMatrix() {
  const tbody = document.getElementById('npdb-table-body');
  if (!tbody) return;

  tbody.innerHTML = NPDB_REPORTING_MATRIX.map(m => `
    <tr class="hover:bg-slate-50 transition">
      <td class="py-3 px-3 font-semibold text-slate-900">
        ${m.action}
        <span class="block text-[11px] text-slate-500 font-normal mt-0.5">${m.consequence}</span>
      </td>
      <td class="py-3 px-3 whitespace-nowrap">
        ${m.reportable 
          ? '<span class="px-2 py-0.5 rounded-full text-[10px] font-bold bg-rose-100 text-rose-800 border border-rose-200">🚨 MANDATORY REPORT</span>' 
          : '<span class="px-2 py-0.5 rounded-full text-[10px] font-bold bg-emerald-100 text-emerald-800 border border-emerald-200">🛡️ NO REPORT</span>'}
      </td>
      <td class="py-3 px-3 font-mono text-[11px] text-slate-600">${m.authority}</td>
    </tr>
  `).join('');
}

// ========================================================
// 2. EXPANDED WMC STATE BOARD DEFENSE CENTER
// ========================================================
function initWMCBoardDefense() {
  renderWMCPhases();
  renderWMCResponseRules();
  renderWMCPhrases();
  renderWMCSanctionsTable();
}

function renderWMCPhases() {
  const container = document.getElementById('wmc-phases-container');
  if (!container) return;

  container.innerHTML = WMC_PHASES.map(p => `
    <div class="p-4 rounded-2xl bg-slate-50 border border-slate-200 space-y-2.5 hover:border-amber-400 transition shadow-xs">
      <div class="flex items-center justify-between">
        <span class="text-xs font-bold text-slate-900 flex items-center gap-2">
          <span class="w-6 h-6 rounded-full bg-amber-100 text-amber-800 flex items-center justify-center text-xs font-mono font-bold">${p.phase}</span>
          ${p.title}
        </span>
        <span class="text-[10px] px-2.5 py-0.5 rounded-full bg-white border border-slate-200 text-amber-900 font-mono font-bold">${p.duration}</span>
      </div>
      <p class="text-xs text-slate-600 leading-relaxed">${p.description}</p>
      <div class="p-3 rounded-xl bg-white border border-slate-200 text-xs text-amber-900 shadow-xs space-y-1">
        <span class="font-bold text-slate-900 block text-[11px]">🛡️ Tactical Priority:</span>
        <p class="text-slate-700 leading-relaxed">${p.tacticalPriority}</p>
      </div>
    </div>
  `).join('');
}

function renderWMCResponseRules() {
  const container = document.getElementById('wmc-response-rules-container');
  if (!container) return;

  container.innerHTML = WMC_RESPONSE_RULES.map(r => `
    <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-200 space-y-1.5 shadow-xs">
      <div class="flex items-center space-x-2">
        <span class="w-5 h-5 rounded-md bg-slate-900 text-white flex items-center justify-center text-[10px] font-mono font-bold">${r.ruleNum}</span>
        <h4 class="text-xs font-bold text-slate-900">${r.title}</h4>
      </div>
      <p class="text-xs text-slate-700">${r.summary}</p>
      <p class="text-[11px] text-slate-500 italic pt-0.5">${r.rationale}</p>
    </div>
  `).join('');
}

function renderWMCPhrases() {
  const container = document.getElementById('wmc-phrases-container');
  if (!container) return;

  container.innerHTML = WMC_PHRASE_DISRUPTER.map(pd => `
    <div class="p-3.5 rounded-2xl bg-slate-50 border border-slate-200 space-y-2 shadow-xs">
      <div class="p-2.5 rounded-xl bg-rose-50 border border-rose-200 text-xs text-rose-800">
        <strong class="text-rose-900 block text-[11px]">❌ Fatal Admission Phrase:</strong>
        "${pd.fatalPhrase}"
      </div>
      <div class="p-2.5 rounded-xl bg-emerald-50 border border-emerald-200 text-xs text-emerald-800">
        <strong class="text-emerald-900 block text-[11px]">🛡️ Master Defense Response:</strong>
        "${pd.masterResponse}"
      </div>
    </div>
  `).join('');
}

function renderWMCSanctionsTable() {
  const tbody = document.getElementById('wmc-sanctions-table-body');
  if (!tbody) return;

  tbody.innerHTML = WMC_SANCTION_HIERARCHY.map(s => `
    <tr class="hover:bg-slate-50 transition">
      <td class="py-3 px-3 font-semibold text-slate-900">
        ${s.sanction}
        <span class="block text-[11px] text-slate-500 font-normal mt-0.5">${s.clinicalImpact}</span>
      </td>
      <td class="py-3 px-3 text-xs text-slate-700 font-medium">${s.severity}</td>
      <td class="py-3 px-3 font-mono text-[11px] text-slate-600">${s.publicRecord}</td>
      <td class="py-3 px-3 whitespace-nowrap">
        ${s.npdbReportable 
          ? '<span class="px-2 py-0.5 rounded-full text-[10px] font-bold bg-rose-100 text-rose-800 border border-rose-200">YES (Reportable)</span>' 
          : '<span class="px-2 py-0.5 rounded-full text-[10px] font-bold bg-emerald-100 text-emerald-800 border border-emerald-200">NO (Shielded)</span>'}
      </td>
    </tr>
  `).join('');
}

// ==========================================
// 3. DEPOSITION MASTERCLASS LOGIC
// ==========================================
function initDepositionMasterclass() {
  renderCardinalRules();
  renderReptileTraps();
  renderMockDeposition();
}

function renderCardinalRules() {
  const container = document.getElementById('cardinal-rules-container');
  if (!container) return;

  container.innerHTML = DEPOSITION_CARDINAL_RULES.map(r => `
    <div class="p-4 rounded-2xl bg-slate-50 border border-slate-200 space-y-2 hover:border-emerald-300 transition shadow-xs">
      <div class="flex items-center space-x-2.5">
        <span class="w-6 h-6 rounded-lg bg-emerald-100 text-emerald-800 flex items-center justify-center text-xs font-bold font-mono">
          ${r.num}
        </span>
        <h4 class="text-xs font-bold text-slate-900">${r.title}</h4>
      </div>
      <p class="text-xs text-slate-600 leading-relaxed">${r.summary}</p>
      <div class="p-2.5 rounded-xl bg-white border border-slate-200 text-xs text-emerald-800 font-semibold shadow-xs">
        <span class="font-bold text-slate-900 block text-[11px] mb-0.5">Execution Rule:</span>
        "${r.rule}"
      </div>
    </div>
  `).join('');
}

function renderReptileTraps() {
  const container = document.getElementById('reptile-traps-container');
  if (!container) return;

  container.innerHTML = REPTILE_THEORY_COUNTERMEASURES.map((trap, idx) => `
    <div class="p-4 rounded-2xl bg-slate-50 border border-slate-200 space-y-3">
      <div class="flex items-center justify-between">
        <span class="text-xs font-bold text-rose-700 flex items-center gap-1.5">
          <i data-lucide="alert-triangle" class="w-3.5 h-3.5 text-rose-600"></i> Plaintiff Trap #${idx + 1}
        </span>
        <span class="text-[10px] px-2 py-0.5 rounded bg-slate-200 text-slate-700 font-mono font-semibold">Reptile Theory</span>
      </div>
      <blockquote class="text-xs italic text-slate-800 bg-white p-2.5 rounded-xl border-l-3 border-rose-500 shadow-xs">
        "${trap.plaintiffTrap}"
      </blockquote>
      <div class="space-y-1.5 text-xs">
        <div class="p-2.5 rounded-xl bg-rose-50 border border-rose-200 text-rose-800">
          <strong class="text-rose-900 block text-[11px]">❌ Dangerous Concession:</strong>
          "${trap.flawedAnswer}"
        </div>
        <div class="p-2.5 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-800">
          <strong class="text-emerald-900 block text-[11px]">🛡️ Master Defense Response:</strong>
          "${trap.masterDefenseResponse}"
        </div>
      </div>
    </div>
  `).join('');
}

function renderMockDeposition() {
  const container = document.getElementById('mock-dep-container');
  if (!container) return;

  const scen = MOCK_DEPOSITION_SCENARIOS[state.currentMockDepIndex];
  if (!scen) return;

  container.innerHTML = `
    <div class="p-4 rounded-2xl bg-slate-50 border border-slate-200 space-y-3">
      <div class="flex items-center justify-between">
        <span class="text-[11px] font-bold text-emerald-800 uppercase tracking-wider">${scen.specialty}</span>
        <div class="flex space-x-1">
          <button id="btn-prev-scen" class="px-2.5 py-1 rounded-lg bg-white hover:bg-slate-100 border border-slate-200 text-[11px] font-semibold text-slate-700 ${state.currentMockDepIndex === 0 ? 'opacity-50 cursor-not-allowed' : ''}">Prev</button>
          <button id="btn-next-scen" class="px-2.5 py-1 rounded-lg bg-white hover:bg-slate-100 border border-slate-200 text-[11px] font-semibold text-slate-700 ${state.currentMockDepIndex === MOCK_DEPOSITION_SCENARIOS.length - 1 ? 'opacity-50 cursor-not-allowed' : ''}">Next</button>
        </div>
      </div>
      <div class="p-3 rounded-xl bg-white border border-slate-200 text-xs text-slate-700 shadow-xs">
        <strong class="text-slate-900 block mb-1">Clinical Case Context:</strong>
        ${scen.context}
      </div>
      <div class="p-3 rounded-xl bg-rose-50 border border-rose-200 text-xs text-rose-800">
        <strong class="text-rose-900 block mb-1">Plaintiff Attorney Cross-Examination Question:</strong>
        "${scen.question}"
      </div>
      <div class="space-y-2 pt-1">
        <span class="text-xs font-bold text-slate-800 block">Select Your Sworn Deposition Response:</span>
        ${scen.options.map((opt, optIdx) => `
          <button class="mock-dep-opt w-full text-left p-3.5 rounded-xl border border-slate-200 hover:border-emerald-500 bg-white hover:bg-emerald-50/40 text-xs text-slate-800 transition space-y-1 block shadow-xs" data-opt-idx="${optIdx}">
            <div class="flex items-center justify-between">
              <span class="font-bold text-slate-900">Option ${String.fromCharCode(65 + optIdx)}</span>
            </div>
            <p class="text-slate-700 leading-relaxed">${opt.text}</p>
          </button>
        `).join('')}
      </div>
      <div id="mock-feedback-box" class="hidden p-4 rounded-2xl border text-xs space-y-2"></div>
    </div>
  `;

  document.getElementById('btn-prev-scen')?.addEventListener('click', () => {
    if (state.currentMockDepIndex > 0) {
      state.currentMockDepIndex--;
      renderMockDeposition();
    }
  });

  document.getElementById('btn-next-scen')?.addEventListener('click', () => {
    if (state.currentMockDepIndex < MOCK_DEPOSITION_SCENARIOS.length - 1) {
      state.currentMockDepIndex++;
      renderMockDeposition();
    }
  });

  document.querySelectorAll('.mock-dep-opt').forEach(btn => {
    btn.addEventListener('click', () => {
      const optIdx = parseInt(btn.getAttribute('data-opt-idx'), 10);
      showMockFeedback(scen, optIdx);
    });
  });
}

function showMockFeedback(scen, optIdx) {
  const opt = scen.options[optIdx];
  const box = document.getElementById('mock-feedback-box');
  if (!box) return;

  box.classList.remove('hidden');
  const isMaster = opt.grade.startsWith('A');

  if (isMaster) {
    box.className = 'p-4 rounded-2xl bg-emerald-50 border border-emerald-300 text-xs text-emerald-900 space-y-1.5 shadow-xs';
    box.innerHTML = `
      <div class="flex items-center justify-between">
        <strong class="text-emerald-800 font-bold text-sm">Grade: ${opt.grade} • ${opt.rating}</strong>
        <span class="text-[10px] px-2.5 py-0.5 rounded bg-emerald-200 text-emerald-900 font-mono font-bold">Trial Ready</span>
      </div>
      <p class="text-slate-700 leading-relaxed">${opt.analysis}</p>
    `;
  } else {
    box.className = 'p-4 rounded-2xl bg-rose-50 border border-rose-300 text-xs text-rose-900 space-y-1.5 shadow-xs';
    box.innerHTML = `
      <div class="flex items-center justify-between">
        <strong class="text-rose-800 font-bold text-sm">Grade: ${opt.grade} • ${opt.rating}</strong>
        <span class="text-[10px] px-2.5 py-0.5 rounded bg-rose-200 text-rose-900 font-mono font-bold">Severe Exposure</span>
      </div>
      <p class="text-slate-700 leading-relaxed">${opt.analysis}</p>
    `;
  }
}

// ==========================================
// 4. FMV CALCULATOR & CHART.JS SETUP
// ==========================================
function initFMVCalculator() {
  const select = document.getElementById('fmv-specialty-select');
  if (!select) return;

  select.innerHTML = SPECIALTY_BENCHMARKS.map(s => `
    <option value="${s.id}" ${s.id === state.selectedSpecialtyId ? 'selected' : ''}>
      ${s.name} (${s.category})
    </option>
  `).join('');

  select.addEventListener('change', (e) => {
    state.selectedSpecialtyId = e.target.value;
    const spec = SPECIALTY_BENCHMARKS.find(s => s.id === state.selectedSpecialtyId);
    if (spec) {
      document.getElementById('input-base-salary').value = spec.compP50;
      document.getElementById('input-target-wrvus').value = spec.wRVUP50;
      document.getElementById('input-conv-factor').value = spec.convFactorP50;
    }
    updateFMVDisplay();
  });

  ['input-base-salary', 'input-target-wrvus', 'input-conv-factor', 'input-call-days'].forEach(id => {
    const el = document.getElementById(id);
    if (el) el.addEventListener('input', updateFMVDisplay);
  });

  updateFMVDisplay();
}

function updateFMVDisplay() {
  const specialtyId = state.selectedSpecialtyId;
  const baseSalary = parseFloat(document.getElementById('input-base-salary')?.value || '0');
  const targetWrvus = parseFloat(document.getElementById('input-target-wrvus')?.value || '0');
  const convFactor = parseFloat(document.getElementById('input-conv-factor')?.value || '0');
  const callDays = parseFloat(document.getElementById('input-call-days')?.value || '0');

  const res = calculateFMVMetrics(specialtyId, baseSalary, targetWrvus, convFactor, callDays);
  const spec = res.specialty;

  document.getElementById('disp-p25-comp').textContent = `$${(spec.compP25 / 1000).toFixed(0)}k`;
  document.getElementById('disp-p25-wrvu').textContent = `${spec.wRVUP25.toLocaleString()} wRVUs`;

  document.getElementById('disp-p50-comp').textContent = `$${(spec.compP50 / 1000).toFixed(0)}k`;
  document.getElementById('disp-p50-wrvu').textContent = `${spec.wRVUP50.toLocaleString()} wRVUs`;

  document.getElementById('disp-p75-comp').textContent = `$${(spec.compP75 / 1000).toFixed(0)}k`;
  document.getElementById('disp-p75-wrvu').textContent = `${spec.wRVUP75.toLocaleString()} wRVUs`;

  document.getElementById('disp-p90-comp').textContent = `$${(spec.compP90 / 1000).toFixed(0)}k`;
  document.getElementById('disp-p90-wrvu').textContent = `${spec.wRVUP90.toLocaleString()} wRVUs`;

  const statusTitle = document.getElementById('fmv-status-title');
  const statusDesc = document.getElementById('fmv-status-description');
  const statusPill = document.getElementById('fmv-status-pill');

  if (statusTitle) statusTitle.textContent = res.statusTitle;
  if (statusDesc) statusDesc.textContent = res.statusDesc;
  if (statusPill) {
    statusPill.textContent = res.statusTitle.split('(')[0].trim();
    statusPill.className = `text-[10px] px-2.5 py-0.5 rounded-full font-bold bg-${res.statusClass}-100 text-${res.statusClass}-800 border border-${res.statusClass}-200`;
  }

  updateFMVChart();
}

function updateFMVChart() {
  if (typeof window === 'undefined' || typeof Chart === 'undefined') return;

  const canvas = document.getElementById('fmvChart');
  if (!canvas) return;

  const spec = SPECIALTY_BENCHMARKS.find(s => s.id === state.selectedSpecialtyId) || SPECIALTY_BENCHMARKS[0];
  const enteredComp = Math.max(
    parseFloat(document.getElementById('input-base-salary')?.value || '0'),
    parseFloat(document.getElementById('input-target-wrvus')?.value || '0') * parseFloat(document.getElementById('input-conv-factor')?.value || '0')
  );

  const labels = ['25th %ile', '50th (Median)', '75th %ile', '90th %ile', 'Your Package'];
  const data = [spec.compP25 / 1000, spec.compP50 / 1000, spec.compP75 / 1000, spec.compP90 / 1000, enteredComp / 1000];

  if (state.fmvChart) {
    state.fmvChart.destroy();
  }

  const ctx = canvas.getContext('2d');
  state.fmvChart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels,
      datasets: [{
        label: 'Total Compensation ($k)',
        data,
        backgroundColor: [
          '#cbd5e1',
          '#059669',
          '#64748b',
          '#d97706',
          '#0f172a'
        ],
        borderRadius: 8,
        borderSkipped: false
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      plugins: {
        legend: { display: false },
        tooltip: {
          callbacks: {
            label: (ctx) => `$${ctx.parsed.y.toLocaleString()}k`
          }
        }
      },
      scales: {
        y: {
          beginAtZero: true,
          grid: { color: '#f1f5f9' },
          ticks: {
            callback: (v) => `$${v}k`,
            font: { family: 'JetBrains Mono', size: 10 }
          }
        },
        x: {
          grid: { display: false },
          ticks: { font: { family: 'Plus Jakarta Sans', size: 10, weight: '600' } }
        }
      }
    }
  });
}

// ==========================================
// 5. MEDICOLEGAL RISK AUDIT SETUP
// ==========================================
function initRiskAudit() {
  const container = document.getElementById('risk-questions-container');
  if (!container) return;

  container.innerHTML = RISK_QUESTIONS.map((q) => `
    <div class="p-4 rounded-2xl bg-slate-50 border border-slate-200 space-y-3" id="card-${q.id}">
      <div class="flex items-center justify-between">
        <h4 class="text-xs font-bold text-slate-900 flex items-center gap-2">
          ${q.title}
        </h4>
        <span class="text-[10px] px-2 py-0.5 rounded bg-slate-200 text-slate-700 font-mono font-semibold">${q.statute}</span>
      </div>
      <p class="text-xs text-slate-600">${q.question}</p>
      <div class="grid grid-cols-1 gap-2 pt-1">
        ${q.options.map((opt, optIndex) => `
          <label class="flex items-start space-x-2.5 p-3 rounded-xl border border-slate-200 bg-white hover:bg-slate-100/80 cursor-pointer transition text-xs text-slate-800 shadow-xs">
            <input type="radio" name="${q.id}" value="${optIndex}" class="mt-0.5 text-emerald-600 focus:ring-emerald-500" ${state.auditAnswers[q.id] === optIndex ? 'checked' : ''}>
            <span class="leading-relaxed">${opt.text}</span>
          </label>
        `).join('')}
      </div>
    </div>
  `).join('');

  container.addEventListener('change', (e) => {
    if (e.target.type === 'radio') {
      state.auditAnswers[e.target.name] = parseInt(e.target.value, 10);
      updateRiskAuditResults();
    }
  });

  document.getElementById('btn-reset-audit')?.addEventListener('click', () => {
    state.auditAnswers = {};
    document.querySelectorAll('#risk-questions-container input[type="radio"]').forEach(r => r.checked = false);
    updateRiskAuditResults();
  });

  updateRiskAuditResults();
}

function updateRiskAuditResults() {
  const res = calculateMVIScore(state.auditAnswers);

  const badge = document.getElementById('mvi-score-badge');
  if (badge) {
    badge.textContent = `MVI: ${res.score} / 100 (${res.tier.toUpperCase()})`;
    badge.className = `px-4 py-1.5 rounded-xl bg-${res.badgeColor}-50 border border-${res.badgeColor}-200 text-${res.badgeColor}-800 font-mono font-bold text-sm`;
  }

  const tierLabel = document.getElementById('mvi-tier-label');
  if (tierLabel) {
    tierLabel.textContent = res.tierLabel;
    tierLabel.className = `text-xs font-bold px-2.5 py-0.5 rounded-full bg-${res.badgeColor}-100 text-${res.badgeColor}-800 border border-${res.badgeColor}-200`;
  }

  const narrative = document.getElementById('mvi-tier-narrative');
  if (narrative) narrative.textContent = res.tierNarrative;

  const recsContainer = document.getElementById('mvi-recs-container');
  if (recsContainer) {
    if (res.criticalDeficiencies.length === 0) {
      recsContainer.innerHTML = `
        <div class="p-3.5 rounded-xl bg-emerald-50 border border-emerald-200 text-xs text-emerald-900">
          ✅ Zero high-exposure vulnerabilities logged. Continue contemporaneous operative reporting and closed-loop test tracking.
        </div>
      `;
    } else {
      recsContainer.innerHTML = `
        <div class="space-y-2">
          <span class="text-[11px] font-bold text-rose-800 uppercase tracking-wider block">Priority Defensive Corrective Actions:</span>
          ${res.criticalDeficiencies.map(d => `
            <div class="p-3 rounded-xl bg-rose-50 border border-rose-200 text-xs text-rose-900 flex items-start gap-2">
              <i data-lucide="alert-circle" class="w-4 h-4 text-rose-600 flex-shrink-0 mt-0.5"></i>
              <div>
                <strong>${d.question} (${d.statute}):</strong>
                <p class="text-slate-700 mt-0.5">Deficiency logged: "${d.selectedText.substring(0, 95)}...". Mandate explicit charting before hospital record closure.</p>
              </div>
            </div>
          `).join('')}
        </div>
      `;
      if (typeof window !== 'undefined' && window.lucide) window.lucide.createIcons();
    }
  }
}

// ==========================================
// 6. MALPRACTICE LITIGATION ROADMAP
// ==========================================
function initMalpracticeLitigation() {
  const stagesContainer = document.getElementById('malpractice-stages-container');
  if (stagesContainer) {
    stagesContainer.innerHTML = MALPRACTICE_LITIGATION_STAGES.map(s => `
      <div class="p-4 rounded-2xl bg-slate-50 border border-slate-200 space-y-2 hover:border-purple-300 transition shadow-xs">
        <div class="flex items-center justify-between">
          <span class="text-xs font-bold text-slate-900 flex items-center gap-2">
            <span class="w-6 h-6 rounded-full bg-purple-100 text-purple-800 flex items-center justify-center text-xs font-mono font-bold">${s.step}</span>
            ${s.stage}
          </span>
          <span class="text-[10px] px-2.5 py-0.5 rounded-full bg-white border border-slate-200 text-purple-900 font-mono font-bold">${s.duration}</span>
        </div>
        <p class="text-xs text-slate-600 leading-relaxed">${s.description}</p>
        <div class="p-2.5 rounded-xl bg-white border border-slate-200 text-xs text-purple-900 shadow-xs">
          <strong class="text-slate-900 block text-[11px] mb-0.5">Physician Strategic Priority:</strong>
          ${s.physicianAction}
        </div>
      </div>
    `).join('');
  }

  const tacticsContainer = document.getElementById('insurance-tactics-container');
  if (tacticsContainer) {
    tacticsContainer.innerHTML = MALPRACTICE_INSURANCE_TACTICS.map(t => `
      <div class="p-4 rounded-2xl bg-slate-50 border border-slate-200 space-y-2 shadow-xs">
        <h4 class="text-xs font-bold text-slate-900">${t.topic}</h4>
        <p class="text-xs text-slate-600 leading-relaxed">${t.analysis}</p>
      </div>
    `).join('');
  }
}

// ==========================================
// 7. STATUTE & PRECEDENT EXPLORER
// ==========================================
function initStatuteExplorer() {
  renderStatutes();

  const searchInput = document.getElementById('statute-search-input');
  if (searchInput) {
    searchInput.addEventListener('input', (e) => {
      renderStatutes(e.target.value.toLowerCase().trim());
    });
  }
}

function renderStatutes(filterQuery = '') {
  const container = document.getElementById('statutes-grid-container');
  if (!container) return;

  const jur = JURISDICTIONS[state.currentJurisdiction] || JURISDICTIONS.WA;
  const stateStatutes = jur.statutes || [];
  const landmarkCases = jur.landmarkCases || [];
  const federal = FEDERAL_REGULATIONS;

  const allItems = [
    ...stateStatutes.map(s => ({ ...s, type: 'State Statute' })),
    ...landmarkCases.map(c => ({
      id: c.citation,
      code: c.citation,
      title: c.topic,
      category: 'Landmark Precedent',
      summary: c.holding,
      keyTakeaway: c.significance,
      type: 'Case Precedent'
    })),
    ...federal.map(f => ({
      id: f.id,
      code: f.citation,
      title: f.title,
      category: f.category,
      summary: f.summary,
      keyTakeaway: f.keyTakeaway,
      type: 'Federal Regulation'
    }))
  ];

  const filtered = allItems.filter(item => {
    if (!filterQuery) return true;
    return (
      item.code?.toLowerCase().includes(filterQuery) ||
      item.title?.toLowerCase().includes(filterQuery) ||
      item.category?.toLowerCase().includes(filterQuery) ||
      item.summary?.toLowerCase().includes(filterQuery) ||
      item.keyTakeaway?.toLowerCase().includes(filterQuery)
    );
  });

  if (filtered.length === 0) {
    container.innerHTML = `
      <div class="col-span-2 p-8 text-center text-slate-400 text-xs">
        No matching statutes or precedents found for "${filterQuery}".
      </div>
    `;
    return;
  }

  container.innerHTML = filtered.map(item => `
    <div class="p-4 rounded-2xl bg-slate-50 border border-slate-200 space-y-2.5 flex flex-col justify-between shadow-xs">
      <div class="space-y-1.5">
        <div class="flex items-center justify-between">
          <span class="text-[10px] px-2 py-0.5 rounded bg-emerald-100 text-emerald-800 font-mono font-bold">${item.code}</span>
          <span class="text-[10px] px-2 py-0.5 rounded bg-white border border-slate-200 text-slate-600 font-semibold">${item.type}</span>
        </div>
        <h4 class="text-xs font-bold text-slate-900">${item.title}</h4>
        <p class="text-xs text-slate-600 leading-relaxed">${item.summary}</p>
      </div>
      <div class="pt-2 border-t border-slate-200 text-xs text-emerald-900 font-medium">
        <strong class="text-slate-900 text-[11px] block">Key Defensive Takeaway:</strong>
        ${item.keyTakeaway}
      </div>
    </div>
  `).join('');
}

// ==========================================
// 8. AI COPILOT SETUP WITH PHI SANITIZATION
// ==========================================
function initAICopilot() {
  const form = document.getElementById('ai-chat-form');
  const input = document.getElementById('ai-chat-input');
  const messagesContainer = document.getElementById('ai-chat-messages');

  if (!form || !input) return;

  form.addEventListener('submit', async (e) => {
    e.preventDefault();
    const query = input.value.trim();
    if (!query) return;

    input.value = '';

    appendChatMessage('user', query);
    const sanitizedQuery = sanitizePHI(query);
    const typingId = appendTypingIndicator();

    try {
      const responseText = await queryAICopilot(sanitizedQuery);
      removeTypingIndicator(typingId);
      appendChatMessage('assistant', responseText);
    } catch (err) {
      removeTypingIndicator(typingId);
      appendChatMessage('assistant', `⚠️ **Error communicating with MDEsq AI Engine:** ${err.message}. If you have a local Gemini API key, click Settings in the top-right to enter it.`);
    }

    messagesContainer.scrollTop = messagesContainer.scrollHeight;
  });
}

async function queryAICopilot(sanitizedPrompt) {
  const systemPrompt = `You are MDEsq, an expert physician-legal advocate and medicolegal strategist for licensed physicians and surgeons.
Your jurisdiction is primarily ${state.currentJurisdiction} (Washington State - RCW 18.71, RCW 7.70, RCW 49.62, WAC 246-919, WMC rules).
You provide sharp, legally grounded, practical advice regarding hospital contract negotiations, Fair Market Value (FMV), Stark Law, non-competes, medical malpractice standard of care defense, depositions/Reptile Theory, and medical board investigations.
Always maintain a direct, professional, protective tone for the physician.
Include statutory citations (RCW/WAC/Stark) where relevant. Include a brief educational disclaimer.`;

  if (state.apiKey) {
    const url = `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=${state.apiKey}`;
    const payload = {
      contents: [
        {
          role: "user",
          parts: [
            { text: `${systemPrompt}\n\nUser Question:\n${sanitizedPrompt}` }
          ]
        }
      ]
    };

    const res = await fetch(url, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });

    if (!res.ok) {
      throw new Error(`Gemini API returned status ${res.status}`);
    }

    const data = await res.json();
    return data.candidates?.[0]?.content?.parts?.[0]?.text || "No response generated.";
  }

  const proxyRes = await fetch('/api/chat', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      prompt: sanitizedPrompt,
      jurisdiction: state.currentJurisdiction
    })
  });

  if (proxyRes.ok) {
    const data = await proxyRes.json();
    return data.response;
  } else {
    return generateOfflineMedicolegalResponse(sanitizedPrompt);
  }
}

function generateOfflineMedicolegalResponse(query) {
  const q = query.toLowerCase();

  if (q.includes('peer review') || q.includes('suspension') || q.includes('sham') || q.includes('npdb')) {
    return `### 🏥 Hospital Peer Review & Summary Suspension Strategy
1. **Never Voluntarily Resign:** Resigning while under inquiry triggers a mandatory adverse report to the NPDB that permanently affects licensing in all 50 states.
2. **The 30-Day Cliff:** Negotiate an interim agreement or leave of absence before Day 30 of suspension to prevent mandatory NPDB reporting.
3. **Sham Peer Review Defense:** If direct competitors are on the committee or bylaws were bypassed, demand an out-of-state external academic review under HCQIA (42 U.S.C. § 11112).`;
  }

  if (q.includes('wmc') || q.includes('board') || q.includes('letter of cooperation') || q.includes('complaint')) {
    return `### 🏛️ Washington Medical Commission (WMC) Defense Guidance
1. **The Certified Record Rule:** Never draft a response without reviewing the complete certified medical record and EMR audit trail.
2. **Objective Phrasing:** Frame the complication as an unavoidable, recognized procedural risk rather than a failure of standard of care.
3. **Seek a STID Resolution:** Advocate for a non-disciplinary Stipulation to Informal Disposition (RCW 18.130.172) to protect your public licensing record and prevent NPDB reporting.`;
  }

  if (q.includes('deposition') || q.includes('reptile') || q.includes('testimony') || q.includes('cross-exam')) {
    return `### 🎙️ Deposition & Cross-Examination Defense Guidance
1. **The 3-Second Pause:** Wait 3 seconds before answering to allow defense counsel to object.
2. **Defeating Reptile Traps:** When asked "Isn't safety always the top priority?", answer: *"Patient care requires balancing clinical risks and benefits tailored to the individual patient's pathology, rather than applying rigid abstract rules."*
3. **Never Speculate:** If you do not remember an encounter from years ago: *"I do not recall independently, but my customary practice is reflected in my contemporaneous note."*`;
  }

  return `### ⚖️ MDEsq Strategic Medicolegal Analysis
Under Washington State Law (RCW 7.70, RCW 18.71, RCW 18.130):
* **Standard of Care (RCW 7.70.040):** Evaluated against an ordinarily prudent health care provider in Washington under similar clinical circumstances.
* **Informed Consent (RCW 7.70.050):** Requires documenting specific material surgical risks and non-surgical alternatives.
* **QA Privilege (RCW 70.41.200):** Peer review discussions and QA incident reports are strictly privileged from civil discovery.`;
}

function appendChatMessage(role, text) {
  const container = document.getElementById('ai-chat-messages');
  if (!container) return;

  const isUser = role === 'user';
  const div = document.createElement('div');
  div.className = `flex items-start space-x-3 ${isUser ? 'justify-end' : ''}`;

  if (isUser) {
    div.innerHTML = `
      <div class="p-3.5 rounded-2xl rounded-tr-none bg-slate-900 text-white max-w-xl text-xs leading-relaxed shadow-sm">
        ${escapeHtml(text)}
      </div>
      <div class="w-8 h-8 rounded-xl bg-slate-200 border border-slate-300 flex items-center justify-center text-slate-700 flex-shrink-0 font-bold text-xs shadow-xs">
        MD
      </div>
    `;
  } else {
    div.innerHTML = `
      <div class="w-8 h-8 rounded-xl bg-slate-900 flex items-center justify-center text-emerald-400 flex-shrink-0 font-bold text-xs shadow-sm">
        ESQ
      </div>
      <div class="p-4 rounded-2xl rounded-tl-none bg-white border border-slate-200 text-slate-800 max-w-2xl text-xs space-y-2 leading-relaxed shadow-xs">
        ${formatMarkdown(text)}
      </div>
    `;
  }

  container.appendChild(div);
  container.scrollTop = container.scrollHeight;
}

function appendTypingIndicator() {
  const container = document.getElementById('ai-chat-messages');
  const id = `typing-${Date.now()}`;
  const div = document.createElement('div');
  div.id = id;
  div.className = 'flex items-start space-x-3';
  div.innerHTML = `
    <div class="w-8 h-8 rounded-xl bg-slate-900 flex items-center justify-center text-emerald-400 flex-shrink-0 font-bold text-xs shadow-sm">
      ESQ
    </div>
    <div class="p-3 rounded-2xl rounded-tl-none bg-white border border-slate-200 text-slate-400 text-xs flex items-center space-x-1.5 shadow-xs">
      <span class="w-2 h-2 rounded-full bg-slate-400 animate-bounce"></span>
      <span class="w-2 h-2 rounded-full bg-slate-400 animate-bounce [animation-delay:0.2s]"></span>
      <span class="w-2 h-2 rounded-full bg-slate-400 animate-bounce [animation-delay:0.4s]"></span>
    </div>
  `;
  container.appendChild(div);
  container.scrollTop = container.scrollHeight;
  return id;
}

function removeTypingIndicator(id) {
  const el = document.getElementById(id);
  if (el) el.remove();
}

function escapeHtml(str) {
  return str.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
}

function formatMarkdown(str) {
  return str
    .replace(/### (.*?)\n/g, '<h4 class="text-xs font-bold text-slate-900 mt-2 mb-1">$1</h4>')
    .replace(/\*\*(.*?)\*\*/g, '<strong class="text-slate-900 font-semibold">$1</strong>')
    .replace(/\*(.*?)\*/g, '<em class="text-slate-700">$1</em>')
    .replace(/\n\n/g, '<br><br>')
    .replace(/\n\* /g, '<br>• ');
}

// Settings Modal
function initSettingsModal() {
  const modal = document.getElementById('settings-modal');
  const openBtn = document.getElementById('btn-open-settings');
  const closeBtn = document.getElementById('btn-close-settings');
  const saveBtn = document.getElementById('btn-save-settings');
  const keyInput = document.getElementById('setting-gemini-key');

  if (keyInput && state.apiKey) {
    keyInput.value = state.apiKey;
  }

  openBtn?.addEventListener('click', () => modal?.classList.remove('hidden'));
  closeBtn?.addEventListener('click', () => modal?.classList.add('hidden'));

  saveBtn?.addEventListener('click', () => {
    state.apiKey = keyInput?.value.trim() || '';
    if (state.apiKey) {
      localStorage.setItem('mdesq_gemini_key', state.apiKey);
    } else {
      localStorage.removeItem('mdesq_gemini_key');
    }
    modal?.classList.add('hidden');
  });
}
