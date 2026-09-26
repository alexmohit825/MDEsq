/**
 * MDEsq - Main Application Controller
 * High-performance, zero-dependency ES Module
 * Light Executive Theme & Contract Document Redline Engine
 */

import { JURISDICTIONS, FEDERAL_REGULATIONS } from './data/statutes.js';
import { SPECIALTY_BENCHMARKS } from './data/specialties.js';
import { DEPOSITION_CARDINAL_RULES, REPTILE_THEORY_COUNTERMEASURES, MOCK_DEPOSITION_SCENARIOS } from './data/depositions.js';
import { SHAM_PEER_REVIEW_FACTORS, SUMMARY_SUSPENSION_PLAYBOOK, NPDB_REPORTING_MATRIX } from './data/peer_review.js';
import { WMC_PHASES, WMC_RESPONSE_RULES, WMC_PHRASE_DISRUPTER, WMC_SANCTION_HIERARCHY } from './data/wmc_defense.js';
import { MALPRACTICE_LITIGATION_STAGES, MALPRACTICE_INSURANCE_TACTICS } from './data/malpractice_timeline.js';
export { SAMPLE_HOSPITAL_CONTRACT, CONTRACT_CLAUSE_RULES, analyzeContractText } from './data/contract_analyzer.js';
import { SAMPLE_HOSPITAL_CONTRACT, CONTRACT_CLAUSE_RULES, analyzeContractText } from './data/contract_analyzer.js';
export { MALPRACTICE_PRECEDENTS, findPrecedentCases } from './data/malpractice_precedents.js';
import { MALPRACTICE_PRECEDENTS, findPrecedentCases } from './data/malpractice_precedents.js';

// Application State
const state = {
  currentJurisdiction: 'WA',
  currentTab: 'tab-fmv-contracts',
  selectedSpecialtyId: 'neurosurgery-spine',
  auditAnswers: {},
  shamAnswers: {},
  apiKey: (typeof localStorage !== 'undefined' && localStorage.getItem('mdesq_gemini_key')) || '',
  currentMockDepIndex: 0,
  fmvChart: null,
  latestContractAnalysis: null,
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

// Zero-PII Sanitizer
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
    initContractDocumentAnalyzer();
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
  renderStatutes();
}

// ========================================================
// 1. CONTRACT DOCUMENT ANALYZER & REDLINE ENGINE
// ========================================================
function initContractDocumentAnalyzer() {
  const fileInput = document.getElementById('contract-file-input');
  const textarea = document.getElementById('contract-raw-text');
  const analyzeBtn = document.getElementById('btn-run-contract-analysis');
  const loadSampleBtn = document.getElementById('btn-load-sample-contract');
  const clearBtn = document.getElementById('btn-clear-contract-text');
  const copyAllBtn = document.getElementById('btn-copy-all-redlines');

  // Load Sample Hospital Contract
  loadSampleBtn?.addEventListener('click', () => {
    if (textarea) {
      textarea.value = SAMPLE_HOSPITAL_CONTRACT;
      runContractAnalysis(SAMPLE_HOSPITAL_CONTRACT);
    }
  });

  // Clear button
  clearBtn?.addEventListener('click', () => {
    if (textarea) textarea.value = '';
  });

  // Analyze button
  analyzeBtn?.addEventListener('click', () => {
    const text = textarea?.value || '';
    runContractAnalysis(text);
  });

  // File Upload Handler (PDF, DOCX, TXT)
  fileInput?.addEventListener('change', async (e) => {
    const file = e.target.files?.[0];
    if (!file) return;

    const fileStatusTag = document.getElementById('file-status-tag');
    const fileNameLabel = document.getElementById('file-name-label');
    if (fileStatusTag && fileNameLabel) {
      fileNameLabel.textContent = file.name;
      fileStatusTag.classList.remove('hidden');
    }

    try {
      const extractedText = await parseDocumentFile(file);
      if (textarea) {
        textarea.value = extractedText;
        runContractAnalysis(extractedText);
      }
    } catch (err) {
      alert(`Error reading document: ${err.message}`);
    }
  });

  // Copy All Redlines Addendum
  copyAllBtn?.addEventListener('click', () => {
    if (!state.latestContractAnalysis || state.latestContractAnalysis.flaggedClauses.length === 0) {
      alert('No redlines generated yet.');
      return;
    }

    const addendum = state.latestContractAnalysis.flaggedClauses.map((c, i) => `
=====================================================
REDLINE AMENDMENT #${i + 1}: ${c.name.toUpperCase()}
Statutory Standard: ${c.statutoryBasis}
-----------------------------------------------------
${c.recommendedRedline}

PHYSICIAN TALKING POINTS:
${c.negotiationScript}
=====================================================
    `).join('\n\n');

    navigator.clipboard.writeText(addendum).then(() => {
      copyAllBtn.innerHTML = `<i data-lucide="check" class="w-3.5 h-3.5 text-emerald-600"></i> Copied Full Addendum!`;
      if (typeof window !== 'undefined' && window.lucide) window.lucide.createIcons();
      setTimeout(() => {
        copyAllBtn.innerHTML = `<i data-lucide="copy" class="w-3.5 h-3.5 text-slate-600"></i> Copy Full Redline Addendum`;
        if (typeof window !== 'undefined' && window.lucide) window.lucide.createIcons();
      }, 2500);
    });
  });

  // Initial Sample Run
  if (textarea && !textarea.value) {
    textarea.value = SAMPLE_HOSPITAL_CONTRACT;
    runContractAnalysis(SAMPLE_HOSPITAL_CONTRACT);
  }
}

async function parseDocumentFile(file) {
  const extension = file.name.split('.').pop().toLowerCase();

  // 1. Text files
  if (extension === 'txt') {
    return await file.text();
  }

  // 2. Word .docx files via mammoth
  if (extension === 'docx' || extension === 'doc') {
    if (typeof mammoth !== 'undefined') {
      const arrayBuffer = await file.arrayBuffer();
      const result = await mammoth.extractRawText({ arrayBuffer });
      return result.value;
    } else {
      return await file.text();
    }
  }

  // 3. PDF files via pdfjsLib
  if (extension === 'pdf') {
    if (typeof pdfjsLib !== 'undefined') {
      const arrayBuffer = await file.arrayBuffer();
      const pdf = await pdfjsLib.getDocument({ data: arrayBuffer }).promise;
      let fullText = '';
      for (let i = 1; i <= pdf.numPages; i++) {
        const page = await pdf.getPage(i);
        const textContent = await page.getTextContent();
        const pageText = textContent.items.map(item => item.str).join(' ');
        fullText += `\n--- Page ${i} ---\n` + pageText;
      }
      return fullText;
    } else {
      throw new Error('PDF parsing library loading. Please paste text directly if needed.');
    }
  }

  return await file.text();
}

function runContractAnalysis(rawText) {
  const analysis = analyzeContractText(rawText);
  state.latestContractAnalysis = analysis;
  renderContractResults(analysis);
}

function renderContractResults(analysis) {
  const gradeBox = document.getElementById('contract-grade-box');
  const flaggedCountPill = document.getElementById('contract-flagged-count');
  const riskSummary = document.getElementById('contract-risk-summary');
  const container = document.getElementById('contract-clauses-container');

  if (gradeBox) {
    gradeBox.textContent = analysis.overallGrade;
    gradeBox.className = `w-14 h-14 rounded-2xl bg-${analysis.gradeColor}-100 text-${analysis.gradeColor}-800 border border-${analysis.gradeColor}-300 flex items-center justify-center text-2xl font-black font-mono shadow-sm`;
  }

  if (flaggedCountPill) {
    flaggedCountPill.textContent = `${analysis.flaggedCount} Red Flag Clauses Flagged`;
    flaggedCountPill.className = `text-xs px-3 py-1 rounded-full font-bold bg-${analysis.gradeColor}-100 text-${analysis.gradeColor}-800 border border-${analysis.gradeColor}-200`;
  }

  if (riskSummary) {
    riskSummary.textContent = analysis.riskSummary;
  }

  if (!container) return;

  if (analysis.flaggedClauses.length === 0) {
    container.innerHTML = `
      <div class="p-8 rounded-3xl bg-emerald-50/80 border-2 border-dashed border-emerald-300 text-center space-y-2">
        <span class="text-3xl">🛡️</span>
        <h4 class="text-sm font-bold text-emerald-900 uppercase tracking-wider">Zero Critical Toxic Clauses Detected</h4>
        <p class="text-xs text-emerald-700 max-w-md mx-auto leading-relaxed">Your draft agreement does not trigger standard predatory non-compete, 100% tail liability, or clawback traps.</p>
      </div>
    `;
    return;
  }

  container.innerHTML = analysis.flaggedClauses.map((clause, idx) => `
    <div class="p-6 rounded-3xl bg-white border border-slate-200/90 space-y-5 hover:border-slate-300 transition shadow-sm">
      
      <!-- Clause Header with Hazard Pill -->
      <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-slate-100 pb-3.5">
        <div class="flex items-center space-x-3">
          <span class="w-7 h-7 rounded-xl bg-rose-600 text-white flex items-center justify-center text-xs font-black font-mono shadow-xs">
            0${idx + 1}
          </span>
          <div>
            <h4 class="text-sm sm:text-base font-extrabold text-slate-900 tracking-tight">${clause.name}</h4>
            <span class="text-[11px] text-slate-500 font-medium">${clause.category}</span>
          </div>
        </div>
        <div class="flex items-center space-x-2">
          <span class="text-[11px] px-3 py-1 rounded-full font-bold ${clause.riskSeverity === 'Critical' ? 'bg-rose-100 text-rose-800 border border-rose-300' : 'bg-amber-100 text-amber-800 border border-amber-300'}">
            ${clause.riskSeverity === 'Critical' ? '🚨 CRITICAL TRAP' : '⚠️ HIGH RISK'}
          </span>
          <span class="text-[11px] px-3 py-1 rounded-full font-mono font-bold bg-slate-100 border border-slate-200 text-slate-700">
            ${clause.statutoryBasis}
          </span>
        </div>
      </div>

      <!-- Two-Column Visual Breakdown: The Trap vs The Legal Standard -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs">
        
        <!-- The Trap Box -->
        <div class="p-4 rounded-2xl bg-rose-50/70 border border-rose-200/80 space-y-2 border-l-4 border-l-rose-500">
          <div class="flex items-center space-x-1.5 text-rose-900 font-bold uppercase tracking-wider text-[10px]">
            <i data-lucide="alert-triangle" class="w-3.5 h-3.5 text-rose-600"></i>
            <span>The Hospital Trap Explained</span>
          </div>
          <p class="text-slate-800 leading-relaxed font-medium">${clause.riskExplanation}</p>
        </div>

        <!-- The Legal Standard Box -->
        <div class="p-4 rounded-2xl bg-slate-50 border border-slate-200 space-y-2 border-l-4 border-l-indigo-500">
          <div class="flex items-center space-x-1.5 text-slate-900 font-bold uppercase tracking-wider text-[10px]">
            <i data-lucide="scale" class="w-3.5 h-3.5 text-indigo-600"></i>
            <span>Statutory Benchmark & Physician Rights</span>
          </div>
          <p class="text-slate-700 leading-relaxed font-medium">${clause.legalStandard}</p>
        </div>

      </div>

      <!-- Recommended Redline Replacement (Copy-Ready Diff) -->
      <div class="p-5 rounded-2xl bg-emerald-50/80 border border-emerald-300 text-xs space-y-3 border-l-4 border-l-emerald-600">
        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-2">
            <div class="p-1 rounded-lg bg-emerald-200/80 text-emerald-900">
              <i data-lucide="check-circle-2" class="w-4 h-4 text-emerald-800"></i>
            </div>
            <div>
              <span class="font-extrabold text-emerald-950 text-xs block tracking-tight">Recommended Redline Replacement</span>
              <span class="text-[10px] text-emerald-700 font-medium">Ready to insert into contract markup</span>
            </div>
          </div>
          <button class="btn-copy-redline px-3.5 py-1.5 rounded-xl bg-white hover:bg-emerald-100 border border-emerald-300 text-emerald-950 font-bold text-xs transition shadow-xs flex items-center gap-1.5" data-redline="${encodeURIComponent(clause.recommendedRedline)}">
            <i data-lucide="copy" class="w-3.5 h-3.5 text-emerald-700"></i>
            <span>Copy Redline</span>
          </button>
        </div>
        <pre class="whitespace-pre-wrap font-mono text-[11px] text-emerald-950 leading-relaxed bg-white p-3.5 rounded-xl border border-emerald-200 shadow-xs select-all">${clause.recommendedRedline}</pre>
      </div>

      <!-- Physician Negotiation Script (The Boardroom Shield) -->
      <div class="p-5 rounded-2xl bg-amber-50/70 border border-amber-300 text-xs space-y-3 border-l-4 border-l-amber-500">
        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-2">
            <div class="p-1 rounded-lg bg-amber-200/80 text-amber-900">
              <i data-lucide="message-square" class="w-4 h-4 text-amber-800"></i>
            </div>
            <div>
              <span class="font-extrabold text-amber-950 text-xs block tracking-tight">Word-for-Word Negotiation Talking Points</span>
              <span class="text-[10px] text-amber-700 font-medium">Verbatim response script for administration meetings</span>
            </div>
          </div>
          <button class="btn-copy-script px-3.5 py-1.5 rounded-xl bg-white hover:bg-amber-100 border border-amber-300 text-amber-950 font-bold text-xs transition shadow-xs flex items-center gap-1.5" data-script="${encodeURIComponent(clause.negotiationScript)}">
            <i data-lucide="copy" class="w-3.5 h-3.5 text-amber-700"></i>
            <span>Copy Script</span>
          </button>
        </div>
        <blockquote class="italic text-slate-900 bg-white p-3.5 rounded-xl border border-amber-200 shadow-xs leading-relaxed font-sans font-medium">
          “${clause.negotiationScript}”
        </blockquote>
      </div>

    </div>
  `).join('');

  if (typeof window !== 'undefined' && window.lucide) window.lucide.createIcons();

  // Attach dynamic copy buttons
  container.querySelectorAll('.btn-copy-redline').forEach(btn => {
    btn.addEventListener('click', () => {
      const text = decodeURIComponent(btn.getAttribute('data-redline'));
      navigator.clipboard.writeText(text).then(() => {
        btn.innerHTML = `<i data-lucide="check" class="w-3.5 h-3.5 text-emerald-700"></i><span>Copied!</span>`;
        if (window.lucide) window.lucide.createIcons();
        setTimeout(() => { 
          btn.innerHTML = `<i data-lucide="copy" class="w-3.5 h-3.5 text-emerald-700"></i><span>Copy Redline</span>`;
          if (window.lucide) window.lucide.createIcons();
        }, 2000);
      });
    });
  });

  container.querySelectorAll('.btn-copy-script').forEach(btn => {
    btn.addEventListener('click', () => {
      const text = decodeURIComponent(btn.getAttribute('data-script'));
      navigator.clipboard.writeText(text).then(() => {
        btn.innerHTML = `<i data-lucide="check" class="w-3.5 h-3.5 text-amber-700"></i><span>Copied!</span>`;
        if (window.lucide) window.lucide.createIcons();
        setTimeout(() => { 
          btn.innerHTML = `<i data-lucide="copy" class="w-3.5 h-3.5 text-amber-700"></i><span>Copy Script</span>`;
          if (window.lucide) window.lucide.createIcons();
        }, 2000);
      });
    });
  });
}

// ========================================================
// 2. PEER REVIEW & SUMMARY SUSPENSION SHIELD
// ========================================================
function initPeerReviewShield() {
  renderShamFactors();
  renderSuspensionPlaybook();
  renderNPDBMatrix();
}

function renderShamFactors() {
  const container = document.getElementById('sham-factors-container');
  if (!container) return;

  // Categorize factors for clear visual grouping
  const categories = [
    { title: "Whistleblower & Retaliation Indicators", icon: "megaphone", color: "rose", factors: SHAM_PEER_REVIEW_FACTORS.slice(0, 3) },
    { title: "Procedural Due Process Violations", icon: "scale", color: "indigo", factors: SHAM_PEER_REVIEW_FACTORS.slice(3, 7) },
    { title: "Economic Competitor Conflicts & Targeting", icon: "briefcase", color: "amber", factors: SHAM_PEER_REVIEW_FACTORS.slice(7) }
  ];

  container.innerHTML = categories.map(cat => `
    <div class="space-y-2.5">
      <div class="flex items-center space-x-2 text-xs font-bold text-slate-800 uppercase tracking-wider">
        <i data-lucide="${cat.icon}" class="w-4 h-4 text-${cat.color}-600"></i>
        <span>${cat.title}</span>
      </div>
      <div class="space-y-2">
        ${cat.factors.map(f => `
          <label class="flex items-start space-x-3.5 p-4 rounded-2xl bg-white border border-slate-200/90 hover:border-blue-400 hover:bg-blue-50/20 cursor-pointer transition text-xs shadow-xs">
            <input type="checkbox" data-factor-id="${f.id}" class="sham-factor-cb mt-1 text-blue-600 focus:ring-blue-500 rounded w-4 h-4 border-slate-300">
            <div class="space-y-1.5 flex-1">
              <div class="flex items-center justify-between">
                <span class="font-extrabold text-slate-900 block text-xs sm:text-sm">${f.title}</span>
                <span class="text-[10px] px-2 py-0.5 rounded-full font-mono font-bold bg-blue-100 text-blue-800">+${f.weight} pts</span>
              </div>
              <p class="text-slate-600 leading-relaxed">${f.description}</p>
              <div class="p-2.5 rounded-xl bg-slate-50 border border-slate-200/70 text-[11px] text-slate-700 flex items-center gap-1.5 font-medium">
                <i data-lucide="file-check" class="w-3.5 h-3.5 text-blue-600 flex-shrink-0"></i>
                <span><strong>Required Evidence:</strong> ${f.evidenceRequired}</span>
              </div>
            </div>
          </label>
        `).join('')}
      </div>
    </div>
  `).join('');

  if (typeof window !== 'undefined' && window.lucide) window.lucide.createIcons();

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
    badge.className = `px-3 py-1.5 rounded-xl bg-${res.badgeClass}-50 text-${res.badgeClass}-800 font-mono font-bold text-xs border border-${res.badgeClass}-200 shadow-xs`;
  }

  const pill = document.getElementById('sham-tier-pill');
  if (pill) {
    pill.textContent = res.tierLabel;
    pill.className = `text-[11px] px-3 py-1 rounded-full font-bold bg-${res.badgeClass}-100 text-${res.badgeClass}-800 border border-${res.badgeClass}-300`;
  }

  const narrative = document.getElementById('sham-tier-narrative');
  if (narrative) narrative.textContent = res.tierNarrative;
}

function renderSuspensionPlaybook() {
  const container = document.getElementById('suspension-playbook-container');
  if (!container) return;

  container.innerHTML = SUMMARY_SUSPENSION_PLAYBOOK.map((p, idx) => `
    <div class="p-4 sm:p-5 rounded-2xl bg-white border border-slate-200/90 space-y-3 hover:border-${p.color}-400 transition shadow-xs border-l-4 border-l-${p.color}-500">
      <div class="flex items-center justify-between">
        <span class="text-xs font-black text-slate-900 flex items-center gap-2">
          <span class="w-6 h-6 rounded-lg bg-${p.color}-100 text-${p.color}-800 flex items-center justify-center text-xs font-mono font-bold">${idx + 1}</span>
          ${p.dayRange}
        </span>
        <span class="text-[10px] px-2.5 py-0.5 rounded-full bg-${p.color}-100 text-${p.color}-800 font-mono font-bold border border-${p.color}-200">${p.phaseTitle}</span>
      </div>
      <ul class="space-y-2 pt-1 text-xs text-slate-700">
        ${p.criticalActions.map(action => `
          <li class="flex items-start gap-2">
            <i data-lucide="check" class="w-3.5 h-3.5 text-${p.color}-600 flex-shrink-0 mt-0.5"></i>
            <span class="leading-relaxed font-medium">${action}</span>
          </li>
        `).join('')}
      </ul>
    </div>
  `).join('');

  if (typeof window !== 'undefined' && window.lucide) window.lucide.createIcons();
}

function renderNPDBMatrix() {
  const tbody = document.getElementById('npdb-table-body');
  if (!tbody) return;

  tbody.innerHTML = NPDB_REPORTING_MATRIX.map(m => `
    <tr class="hover:bg-slate-50/80 transition">
      <td class="py-3 px-3 font-semibold text-slate-900">
        ${m.action}
        <span class="block text-[11px] text-slate-500 font-normal mt-0.5">${m.consequence}</span>
      </td>
      <td class="py-3 px-3 whitespace-nowrap">
        ${m.reportable 
          ? '<span class="px-2.5 py-1 rounded-full text-[10px] font-extrabold bg-rose-100 text-rose-800 border border-rose-300">🚨 MANDATORY REPORT</span>' 
          : '<span class="px-2.5 py-1 rounded-full text-[10px] font-extrabold bg-emerald-100 text-emerald-800 border border-emerald-300">🛡️ NO REPORT (SHIELDED)</span>'}
      </td>
      <td class="py-3 px-3 font-mono text-[11px] text-slate-600">${m.authority}</td>
    </tr>
  `).join('');
}

// ========================================================
// 3. EXPANDED WMC STATE BOARD DEFENSE CENTER
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

  container.innerHTML = WMC_PHASES.map((p, idx) => `
    <div class="p-5 rounded-2xl bg-white border border-slate-200/90 space-y-3 hover:border-amber-400 transition shadow-xs border-l-4 border-l-amber-500">
      <div class="flex items-center justify-between">
        <span class="text-xs sm:text-sm font-extrabold text-slate-900 flex items-center gap-2">
          <span class="w-6 h-6 rounded-lg bg-amber-100 text-amber-800 flex items-center justify-center text-xs font-mono font-bold">${idx + 1}</span>
          Phase ${p.phase}: ${p.title}
        </span>
        <span class="text-[10px] px-2.5 py-0.5 rounded-full bg-slate-100 border border-slate-200 text-amber-900 font-mono font-bold">⏱️ ${p.duration}</span>
      </div>
      <p class="text-xs text-slate-600 leading-relaxed font-medium">${p.description}</p>
      <div class="p-3.5 rounded-xl bg-amber-50/70 border border-amber-200 text-xs text-amber-950 shadow-xs space-y-1">
        <span class="font-extrabold text-amber-900 block text-[11px] uppercase tracking-wider flex items-center gap-1.5">
          <i data-lucide="shield" class="w-3.5 h-3.5 text-amber-700"></i> Tactical Priority:
        </span>
        <p class="text-slate-800 leading-relaxed font-medium">${p.tacticalPriority}</p>
      </div>
    </div>
  `).join('');

  if (typeof window !== 'undefined' && window.lucide) window.lucide.createIcons();
}

function renderWMCResponseRules() {
  const container = document.getElementById('wmc-response-rules-container');
  if (!container) return;

  container.innerHTML = WMC_RESPONSE_RULES.map((r, idx) => `
    <div class="p-4 rounded-2xl bg-white border border-slate-200/90 space-y-2 shadow-xs border-l-4 border-l-slate-900">
      <div class="flex items-center space-x-2">
        <span class="w-6 h-6 rounded-lg bg-slate-900 text-white flex items-center justify-center text-xs font-mono font-bold">0${idx + 1}</span>
        <h4 class="text-xs sm:text-sm font-extrabold text-slate-900">${r.title}</h4>
      </div>
      <p class="text-xs text-slate-700 font-medium leading-relaxed">${r.summary}</p>
      <p class="text-[11px] text-slate-500 italic pt-1 border-t border-slate-100">⚖️ ${r.rationale}</p>
    </div>
  `).join('');
}

function renderWMCPhrases() {
  const container = document.getElementById('wmc-phrases-container');
  if (!container) return;

  container.innerHTML = WMC_PHRASE_DISRUPTER.map((pd, idx) => `
    <div class="p-4 rounded-2xl bg-white border border-slate-200/90 space-y-3 shadow-xs">
      <div class="flex items-center justify-between border-b border-slate-100 pb-2">
        <span class="text-[10px] font-bold text-slate-500 uppercase tracking-wider">Disrupter #${idx + 1}</span>
        <button class="btn-copy-wmc-phrase text-[10px] text-emerald-700 hover:text-emerald-900 font-bold flex items-center gap-1" data-phrase="${encodeURIComponent(pd.masterResponse)}">
          <i data-lucide="copy" class="w-3 h-3"></i> Copy Master Phrasing
        </button>
      </div>
      <div class="p-3 rounded-xl bg-rose-50 border border-rose-200 text-xs text-rose-900 border-l-4 border-l-rose-500 space-y-1">
        <strong class="text-rose-950 block text-[10px] uppercase font-black">❌ Fatal Admission to Never Utter:</strong>
        <span class="font-medium italic">“${pd.fatalPhrase}”</span>
      </div>
      <div class="p-3 rounded-xl bg-emerald-50 border border-emerald-200 text-xs text-emerald-950 border-l-4 border-l-emerald-600 space-y-1">
        <strong class="text-emerald-950 block text-[10px] uppercase font-black">🛡️ Master Defense Phrasing:</strong>
        <span class="font-medium">“${pd.masterResponse}”</span>
      </div>
    </div>
  `).join('');

  if (typeof window !== 'undefined' && window.lucide) window.lucide.createIcons();

  container.querySelectorAll('.btn-copy-wmc-phrase').forEach(btn => {
    btn.addEventListener('click', () => {
      const text = decodeURIComponent(btn.getAttribute('data-phrase'));
      navigator.clipboard.writeText(text).then(() => {
        btn.innerHTML = `<i data-lucide="check" class="w-3 h-3 text-emerald-700"></i> Copied!`;
        if (window.lucide) window.lucide.createIcons();
        setTimeout(() => {
          btn.innerHTML = `<i data-lucide="copy" class="w-3 h-3"></i> Copy Master Phrasing`;
          if (window.lucide) window.lucide.createIcons();
        }, 2000);
      });
    });
  });
}

function renderWMCSanctionsTable() {
  const tbody = document.getElementById('wmc-sanctions-table-body');
  if (!tbody) return;

  tbody.innerHTML = WMC_SANCTION_HIERARCHY.map(s => `
    <tr class="hover:bg-slate-50/80 transition">
      <td class="py-3 px-3 font-semibold text-slate-900">
        ${s.sanction}
        <span class="block text-[11px] text-slate-500 font-normal mt-0.5">${s.clinicalImpact}</span>
      </td>
      <td class="py-3 px-3 text-xs text-slate-700 font-medium">${s.severity}</td>
      <td class="py-3 px-3 font-mono text-[11px] text-slate-600">${s.publicRecord}</td>
      <td class="py-3 px-3 whitespace-nowrap">
        ${s.npdbReportable 
          ? '<span class="px-2.5 py-1 rounded-full text-[10px] font-bold bg-rose-100 text-rose-800 border border-rose-300">YES (Reportable)</span>' 
          : '<span class="px-2.5 py-1 rounded-full text-[10px] font-bold bg-emerald-100 text-emerald-800 border border-emerald-300">NO (STID Shielded)</span>'}
      </td>
    </tr>
  `).join('');
}

// ==========================================
// 4. DEPOSITION MASTERCLASS LOGIC
// ==========================================
function initDepositionMasterclass() {
  renderCardinalRules();
  renderReptileTraps();
  renderMockDeposition();
}

function renderCardinalRules() {
  const container = document.getElementById('cardinal-rules-container');
  if (!container) return;

  container.innerHTML = DEPOSITION_CARDINAL_RULES.map((r, idx) => `
    <div class="p-5 rounded-2xl bg-white border border-slate-200/90 space-y-3 hover:border-emerald-300 transition shadow-xs border-l-4 border-l-emerald-600">
      <div class="flex items-center justify-between">
        <div class="flex items-center space-x-2.5">
          <span class="w-6 h-6 rounded-lg bg-emerald-100 text-emerald-800 flex items-center justify-center text-xs font-black font-mono">
            0${idx + 1}
          </span>
          <h4 class="text-xs sm:text-sm font-extrabold text-slate-900">${r.title}</h4>
        </div>
        <span class="text-[10px] px-2 py-0.5 rounded bg-emerald-50 text-emerald-800 font-mono font-bold">Rule #${r.num}</span>
      </div>
      <p class="text-xs text-slate-600 leading-relaxed font-medium">${r.summary}</p>
      <div class="p-3 rounded-xl bg-emerald-50/70 border border-emerald-200 text-xs text-emerald-950 font-semibold shadow-xs space-y-1">
        <span class="font-extrabold text-emerald-900 block text-[10px] uppercase tracking-wider">The Golden Execution Commandment:</span>
        <blockquote class="italic">“${r.rule}”</blockquote>
      </div>
    </div>
  `).join('');
}

function renderReptileTraps() {
  const container = document.getElementById('reptile-traps-container');
  if (!container) return;

  container.innerHTML = REPTILE_THEORY_COUNTERMEASURES.map((trap, idx) => `
    <div class="p-5 rounded-2xl bg-white border border-slate-200/90 space-y-3 shadow-xs">
      <div class="flex items-center justify-between border-b border-slate-100 pb-2">
        <span class="text-xs font-extrabold text-rose-700 flex items-center gap-1.5">
          <i data-lucide="alert-triangle" class="w-4 h-4 text-rose-600"></i> Plaintiff Reptile Ambush #${idx + 1}
        </span>
        <button class="btn-copy-reptile-defense text-[10px] text-emerald-700 hover:text-emerald-900 font-bold flex items-center gap-1" data-defense="${encodeURIComponent(trap.masterDefenseResponse)}">
          <i data-lucide="copy" class="w-3 h-3"></i> Copy Defense Response
        </button>
      </div>
      
      <!-- Plaintiff Question -->
      <blockquote class="text-xs italic text-slate-900 bg-rose-50/60 p-3 rounded-xl border border-rose-200 border-l-4 border-l-rose-500 shadow-xs font-medium">
        “${trap.plaintiffTrap}”
      </blockquote>

      <!-- Attack vs Defense Grid -->
      <div class="space-y-2 text-xs">
        <div class="p-3 rounded-xl bg-slate-50 border border-slate-200 text-slate-800 space-y-0.5">
          <strong class="text-rose-800 block text-[10px] uppercase font-black">❌ Why The Fatal Concession Fails:</strong>
          <span class="font-medium">“${trap.flawedAnswer}”</span>
        </div>
        <div class="p-3 rounded-xl bg-emerald-50 border border-emerald-200 text-emerald-950 border-l-4 border-l-emerald-600 space-y-0.5">
          <strong class="text-emerald-900 block text-[10px] uppercase font-black">🛡️ Master Countermeasure Response:</strong>
          <span class="font-medium">“${trap.masterDefenseResponse}”</span>
        </div>
      </div>
    </div>
  `).join('');

  if (typeof window !== 'undefined' && window.lucide) window.lucide.createIcons();

  container.querySelectorAll('.btn-copy-reptile-defense').forEach(btn => {
    btn.addEventListener('click', () => {
      const text = decodeURIComponent(btn.getAttribute('data-defense'));
      navigator.clipboard.writeText(text).then(() => {
        btn.innerHTML = `<i data-lucide="check" class="w-3 h-3 text-emerald-700"></i> Copied!`;
        if (window.lucide) window.lucide.createIcons();
        setTimeout(() => {
          btn.innerHTML = `<i data-lucide="copy" class="w-3 h-3"></i> Copy Defense Response`;
          if (window.lucide) window.lucide.createIcons();
        }, 2000);
      });
    });
  });
}

function renderMockDeposition() {
  const container = document.getElementById('mock-dep-container');
  if (!container) return;

  const scen = MOCK_DEPOSITION_SCENARIOS[state.currentMockDepIndex];
  if (!scen) return;

  container.innerHTML = `
    <div class="p-6 rounded-3xl bg-white border border-slate-200/90 space-y-4 shadow-sm">
      <div class="flex items-center justify-between border-b border-slate-100 pb-3">
        <div class="flex items-center space-x-2">
          <span class="text-[11px] px-3 py-0.5 rounded-full font-extrabold bg-emerald-100 text-emerald-900 border border-emerald-300 uppercase tracking-wider">${scen.specialty}</span>
          <span class="text-xs text-slate-500 font-medium">Scenario ${state.currentMockDepIndex + 1} of ${MOCK_DEPOSITION_SCENARIOS.length}</span>
        </div>
        <div class="flex space-x-1.5">
          <button id="btn-prev-scen" class="px-3 py-1.5 rounded-xl bg-slate-50 hover:bg-slate-100 border border-slate-200 text-xs font-bold text-slate-700 transition ${state.currentMockDepIndex === 0 ? 'opacity-40 cursor-not-allowed' : ''}">Prev</button>
          <button id="btn-next-scen" class="px-3 py-1.5 rounded-xl bg-slate-900 hover:bg-slate-800 text-white text-xs font-bold transition ${state.currentMockDepIndex === MOCK_DEPOSITION_SCENARIOS.length - 1 ? 'opacity-40 cursor-not-allowed' : ''}">Next Scenario</button>
        </div>
      </div>

      <!-- Clinical Context Card -->
      <div class="p-4 rounded-2xl bg-slate-50 border border-slate-200 text-xs text-slate-700 shadow-xs space-y-1 border-l-4 border-l-indigo-500">
        <strong class="text-slate-900 block text-[11px] uppercase font-black tracking-wider flex items-center gap-1.5">
          <i data-lucide="file-text" class="w-3.5 h-3.5 text-indigo-600"></i> Clinical Case Context & Complication:
        </strong>
        <p class="leading-relaxed font-medium">${scen.context}</p>
      </div>

      <!-- Plaintiff Question -->
      <div class="p-4 rounded-2xl bg-rose-50 border border-rose-200 text-xs text-rose-950 border-l-4 border-l-rose-500 shadow-xs space-y-1">
        <strong class="text-rose-950 block text-[11px] uppercase font-black tracking-wider flex items-center gap-1.5">
          <i data-lucide="crosshair" class="w-3.5 h-3.5 text-rose-600"></i> Plaintiff Attorney Cross-Examination Question:
        </strong>
        <blockquote class="text-sm font-semibold italic">“${scen.question}”</blockquote>
      </div>

      <!-- Sworn Response Options -->
      <div class="space-y-2.5 pt-1">
        <span class="text-xs font-black text-slate-900 uppercase tracking-wider block">Select Your Sworn Deposition Response:</span>
        ${scen.options.map((opt, optIdx) => `
          <button class="mock-dep-opt w-full text-left p-4 rounded-2xl border border-slate-200 hover:border-emerald-500 bg-white hover:bg-emerald-50/30 text-xs text-slate-800 transition space-y-1 block shadow-xs group" data-opt-idx="${optIdx}">
            <div class="flex items-center justify-between">
              <span class="font-extrabold text-slate-900 group-hover:text-emerald-900">Option ${String.fromCharCode(65 + optIdx)}</span>
              <span class="text-[10px] text-slate-400 group-hover:text-emerald-700 font-mono">Click to Test</span>
            </div>
            <p class="text-slate-700 leading-relaxed font-medium">“${opt.text}”</p>
          </button>
        `).join('')}
      </div>

      <!-- Feedback Result Box -->
      <div id="mock-feedback-box" class="hidden p-5 rounded-2xl border text-xs space-y-2"></div>
    </div>
  `;

  if (typeof window !== 'undefined' && window.lucide) window.lucide.createIcons();

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
    box.className = 'p-5 rounded-2xl bg-emerald-50 border border-emerald-300 text-xs text-emerald-950 space-y-2 shadow-sm border-l-4 border-l-emerald-600';
    box.innerHTML = `
      <div class="flex items-center justify-between border-b border-emerald-200 pb-2">
        <strong class="text-emerald-950 font-black text-sm flex items-center gap-1.5">
          <i data-lucide="shield-check" class="w-4 h-4 text-emerald-700"></i> Grade: ${opt.grade} • ${opt.rating}
        </strong>
        <span class="text-[10px] px-3 py-0.5 rounded-full bg-emerald-200 text-emerald-900 font-mono font-bold">Trial Ready Master Defense</span>
      </div>
      <p class="text-slate-800 leading-relaxed font-medium">${opt.analysis}</p>
    `;
  } else {
    box.className = 'p-5 rounded-2xl bg-rose-50 border border-rose-300 text-xs text-rose-950 space-y-2 shadow-sm border-l-4 border-l-rose-600';
    box.innerHTML = `
      <div class="flex items-center justify-between border-b border-rose-200 pb-2">
        <strong class="text-rose-950 font-black text-sm flex items-center gap-1.5">
          <i data-lucide="alert-octagon" class="w-4 h-4 text-rose-700"></i> Grade: ${opt.grade} • ${opt.rating}
        </strong>
        <span class="text-[10px] px-3 py-0.5 rounded-full bg-rose-200 text-rose-900 font-mono font-bold">Severe Liability Exposure</span>
      </div>
      <p class="text-slate-800 leading-relaxed font-medium">${opt.analysis}</p>
    `;
  }

  if (typeof window !== 'undefined' && window.lucide) window.lucide.createIcons();
}

// ==========================================
// 5. FMV CALCULATOR & CHART.JS SETUP
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
// 6. MEDICOLEGAL RISK AUDIT SETUP
// ==========================================
function initRiskAudit() {
  const container = document.getElementById('risk-questions-container');
  if (!container) return;

  container.innerHTML = RISK_QUESTIONS.map((q, idx) => `
    <div class="p-5 rounded-2xl bg-white border border-slate-200/90 space-y-3 shadow-xs border-l-4 border-l-slate-700" id="card-${q.id}">
      <div class="flex items-center justify-between">
        <h4 class="text-xs sm:text-sm font-extrabold text-slate-900 flex items-center gap-2">
          <span class="w-6 h-6 rounded-lg bg-slate-900 text-white flex items-center justify-center text-xs font-mono font-bold">${idx + 1}</span>
          ${q.title}
        </h4>
        <span class="text-[10px] px-2.5 py-0.5 rounded-full bg-slate-100 border border-slate-200 text-slate-700 font-mono font-bold">${q.statute}</span>
      </div>
      <p class="text-xs text-slate-600 leading-relaxed font-medium">${q.question}</p>
      <div class="grid grid-cols-1 gap-2.5 pt-1">
        ${q.options.map((opt, optIndex) => `
          <label class="flex items-start space-x-3 p-3.5 rounded-xl border border-slate-200/80 bg-slate-50/50 hover:bg-emerald-50/40 hover:border-emerald-400 cursor-pointer transition text-xs text-slate-800 shadow-xs">
            <input type="radio" name="${q.id}" value="${optIndex}" class="mt-0.5 text-emerald-600 focus:ring-emerald-500 w-4 h-4" ${state.auditAnswers[q.id] === optIndex ? 'checked' : ''}>
            <span class="leading-relaxed font-medium">${opt.text}</span>
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
    badge.className = `px-4 py-1.5 rounded-xl bg-${res.badgeColor}-50 border border-${res.badgeColor}-200 text-${res.badgeColor}-800 font-mono font-bold text-sm shadow-xs`;
  }

  const tierLabel = document.getElementById('mvi-tier-label');
  if (tierLabel) {
    tierLabel.textContent = res.tierLabel;
    tierLabel.className = `text-xs font-bold px-3 py-1 rounded-full bg-${res.badgeColor}-100 text-${res.badgeColor}-800 border border-${res.badgeColor}-300`;
  }

  const narrative = document.getElementById('mvi-tier-narrative');
  if (narrative) narrative.textContent = res.tierNarrative;

  const recsContainer = document.getElementById('mvi-recs-container');
  if (recsContainer) {
    if (res.criticalDeficiencies.length === 0) {
      recsContainer.innerHTML = `
        <div class="p-4 rounded-2xl bg-emerald-50 border border-emerald-300 text-xs text-emerald-950 flex items-center gap-2 border-l-4 border-l-emerald-600">
          <i data-lucide="shield-check" class="w-5 h-5 text-emerald-700 flex-shrink-0"></i>
          <span><strong>Zero High-Exposure Vulnerabilities Logged.</strong> Continue contemporaneous operative reporting and closed-loop test tracking.</span>
        </div>
      `;
    } else {
      recsContainer.innerHTML = `
        <div class="space-y-2.5">
          <span class="text-[11px] font-black text-rose-900 uppercase tracking-wider block">Priority Defensive Corrective Actions:</span>
          ${res.criticalDeficiencies.map(d => `
            <div class="p-4 rounded-2xl bg-rose-50 border border-rose-200 text-xs text-rose-950 flex items-start gap-2.5 border-l-4 border-l-rose-500 shadow-xs">
              <i data-lucide="alert-circle" class="w-4 h-4 text-rose-600 flex-shrink-0 mt-0.5"></i>
              <div>
                <strong class="text-rose-950 block">${d.question} (${d.statute}):</strong>
                <p class="text-slate-800 mt-1 leading-relaxed">Deficiency logged: "${d.selectedText.substring(0, 95)}...". Mandate explicit charting before hospital record closure.</p>
              </div>
            </div>
          `).join('')}
        </div>
      `;
    }
    if (typeof window !== 'undefined' && window.lucide) window.lucide.createIcons();
  }
}

// ==========================================
// 7. MALPRACTICE LITIGATION & PRECEDENT RADAR
// ==========================================
let speechRecognitionInstance = null;
let isRecordingVoice = false;

const PRESET_CASE_TEXTS = {
  'dural-tear': "Patient underwent elective L4-L5 lumbar discectomy for herniated nucleus pulposus. Intraoperatively, an incidental dural tear was encountered during scar tissue dissection. The surgeon performed primary watertight suture repair with 5-0 Prolene and reinforced with DuraSeal. Postoperatively, patient developed persistent positional headache and pseudomeningocele requiring revision surgery. Plaintiff alleging lack of informed consent and negligent surgical technique.",
  'cauda-equina': "Patient presented to Emergency Department with acute lower back pain, bilateral lower extremity paresthesias, and urinary hesitation. Emergency physician discharged on muscle relaxants without checking post-void residual or perianal sensation. 36 hours later patient returned with complete saddle anesthesia and cauda equina syndrome.",
  'pedicle-screw': "Patient underwent posterior instrumented lumbar fusion. Post-op CT demonstrated a 2.5 mm medial wall pedicle screw breach contacting the L5 nerve root with new motor weakness. Surgeon returned to OR on post-op day 2 to revise screw. Plaintiff claiming negligent hardware placement.",
  'retained-sponge': "Following complex open abdominal surgery, patient developed persistent fever and abdominal pain. Imaging 3 months later revealed a retained laparotomy sponge in the peritoneal cavity despite nursing count reported as correct.",
  'imaging-comm': "Outpatient CT scan revealed a 1.8 cm suspicious pulmonary nodule. Radiologist noted recommendation for follow-up in the body of the report but did not flag or directly communicate with the ordering physician. Primary care physician never received notification; patient diagnosed 2 years later with metastatic lung cancer."
};

function initMalpracticeLitigation() {
  initPrecedentFinder();

  const stagesContainer = document.getElementById('malpractice-stages-container');
  if (stagesContainer) {
    stagesContainer.innerHTML = MALPRACTICE_LITIGATION_STAGES.map((s, idx) => `
      <div class="p-5 rounded-2xl bg-white border border-slate-200/90 space-y-3 hover:border-purple-400 transition shadow-xs border-l-4 border-l-purple-600">
        <div class="flex items-center justify-between">
          <span class="text-xs sm:text-sm font-extrabold text-slate-900 flex items-center gap-2">
            <span class="w-6 h-6 rounded-lg bg-purple-100 text-purple-800 flex items-center justify-center text-xs font-mono font-bold">${idx + 1}</span>
            ${s.stage}
          </span>
          <span class="text-[10px] px-2.5 py-0.5 rounded-full bg-slate-100 border border-slate-200 text-purple-900 font-mono font-bold">⏱️ ${s.duration}</span>
        </div>
        <p class="text-xs text-slate-600 leading-relaxed font-medium">${s.description}</p>
        <div class="p-3 rounded-xl bg-purple-50/70 border border-purple-200 text-xs text-purple-950 shadow-xs space-y-1">
          <strong class="text-purple-900 block text-[11px] uppercase tracking-wider flex items-center gap-1.5">
            <i data-lucide="shield" class="w-3.5 h-3.5 text-purple-700"></i> Physician Strategic Priority:
          </strong>
          <p class="text-slate-800 leading-relaxed font-medium">${s.physicianAction}</p>
        </div>
      </div>
    `).join('');
  }

  const tacticsContainer = document.getElementById('insurance-tactics-container');
  if (tacticsContainer) {
    tacticsContainer.innerHTML = MALPRACTICE_INSURANCE_TACTICS.map(t => `
      <div class="p-4 rounded-2xl bg-white border border-slate-200/90 space-y-2 shadow-xs border-l-4 border-l-slate-900">
        <h4 class="text-xs sm:text-sm font-extrabold text-slate-900">${t.topic}</h4>
        <p class="text-xs text-slate-600 leading-relaxed font-medium">${t.analysis}</p>
      </div>
    `).join('');
  }

  if (typeof window !== 'undefined' && window.lucide) window.lucide.createIcons();
}

function initPrecedentFinder() {
  const input = document.getElementById('precedent-case-input');
  const searchBtn = document.getElementById('btn-find-precedents');
  const clearBtn = document.getElementById('btn-clear-precedent');
  const voiceBtn = document.getElementById('btn-precedent-voice');
  const voiceIndicator = document.getElementById('voice-status-indicator');
  const micIcon = document.getElementById('icon-voice-mic');
  const jurSelect = document.getElementById('precedent-jurisdiction-select');

  // Preset Scenario Buttons
  document.querySelectorAll('.btn-preset-case').forEach(btn => {
    btn.addEventListener('click', () => {
      const presetKey = btn.getAttribute('data-preset');
      const text = PRESET_CASE_TEXTS[presetKey];
      if (text && input) {
        input.value = text;
        runPrecedentAnalysis(text, jurSelect?.value || 'ALL');
      }
    });
  });

  // Clear Button
  clearBtn?.addEventListener('click', () => {
    if (input) input.value = '';
    const resultsContainer = document.getElementById('precedent-results-container');
    if (resultsContainer) {
      resultsContainer.innerHTML = `
        <div class="p-8 rounded-3xl bg-slate-50/70 border border-slate-200 text-center space-y-2">
          <span class="text-3xl">⚖️</span>
          <h4 class="text-sm font-bold text-slate-800">No Case Scenario Entered Yet</h4>
          <p class="text-xs text-slate-500 max-w-md mx-auto">Type or dictate your clinical case above or click a scenario preset to analyze matching precedents across WA, OR, CA, and NY.</p>
        </div>
      `;
    }
  });

  // Search Button
  searchBtn?.addEventListener('click', () => {
    const text = input?.value.trim();
    if (!text) return;
    runPrecedentAnalysis(text, jurSelect?.value || 'ALL');
  });

  jurSelect?.addEventListener('change', () => {
    const text = input?.value.trim();
    if (text) {
      runPrecedentAnalysis(text, jurSelect.value);
    }
  });

  // Voice Dictation (Speech-to-Text via Web Speech API)
  if (typeof window !== 'undefined' && ('SpeechRecognition' in window || 'webkitSpeechRecognition' in window)) {
    const SpeechRec = window.SpeechRecognition || window.webkitSpeechRecognition;
    speechRecognitionInstance = new SpeechRec();
    speechRecognitionInstance.continuous = false;
    speechRecognitionInstance.interimResults = true;
    speechRecognitionInstance.lang = 'en-US';

    speechRecognitionInstance.onstart = () => {
      isRecordingVoice = true;
      voiceIndicator?.classList.remove('hidden');
      voiceIndicator?.classList.add('flex');
      if (micIcon) micIcon.className = "w-4 h-4 text-rose-600 animate-pulse";
    };

    speechRecognitionInstance.onresult = (event) => {
      let interimTranscript = '';
      for (let i = event.resultIndex; i < event.results.length; ++i) {
        if (event.results[i].isFinal) {
          if (input) {
            input.value = (input.value ? input.value + ' ' : '') + event.results[i][0].transcript;
          }
        } else {
          interimTranscript += event.results[i][0].transcript;
        }
      }
    };

    speechRecognitionInstance.onerror = (event) => {
      console.warn('Speech recognition error:', event.error);
      stopVoiceRecording();
    };

    speechRecognitionInstance.onend = () => {
      stopVoiceRecording();
      const text = input?.value.trim();
      if (text) {
        runPrecedentAnalysis(text, jurSelect?.value || 'ALL');
      }
    };

    voiceBtn?.addEventListener('click', () => {
      if (isRecordingVoice) {
        speechRecognitionInstance.stop();
      } else {
        try {
          speechRecognitionInstance.start();
        } catch (e) {
          console.warn('Could not start speech recognition:', e);
        }
      }
    });
  } else {
    if (voiceBtn) {
      voiceBtn.title = "Voice dictation not supported in this browser (Use Chrome or Edge)";
      voiceBtn.classList.add('opacity-50');
    }
  }
}

function stopVoiceRecording() {
  isRecordingVoice = false;
  const voiceIndicator = document.getElementById('voice-status-indicator');
  const micIcon = document.getElementById('icon-voice-mic');
  voiceIndicator?.classList.add('hidden');
  voiceIndicator?.classList.remove('flex');
  if (micIcon) micIcon.className = "w-4 h-4 text-purple-600";
}

export function runPrecedentAnalysis(rawText, jurisdictionFilter = 'ALL') {
  const container = document.getElementById('precedent-results-container');
  if (!container) return;

  const sanitized = sanitizePHI(rawText);
  const matches = findPrecedentCases(sanitized, jurisdictionFilter);

  if (matches.length === 0) {
    container.innerHTML = `
      <div class="p-8 rounded-3xl bg-amber-50/70 border border-amber-200 text-center space-y-2">
        <span class="text-3xl">🔍</span>
        <h4 class="text-sm font-bold text-amber-950">No Direct Precedent Matches Found in Local Corpus</h4>
        <p class="text-xs text-slate-600 max-w-md mx-auto">Try broadening your clinical keywords or selecting "All Jurisdictions". MDEsq AI Copilot can also provide live case analysis via edge synthesis.</p>
      </div>
    `;
    return;
  }

  container.innerHTML = `
    <!-- Precedent Header Summary -->
    <div class="p-5 rounded-3xl bg-gradient-to-r from-purple-50 via-slate-50 to-white border border-purple-200 flex flex-col sm:flex-row sm:items-center justify-between gap-3 shadow-xs">
      <div class="flex items-center space-x-3">
        <div class="w-10 h-10 rounded-2xl bg-purple-600 text-white flex items-center justify-center font-black text-sm">
          ${matches.length}
        </div>
        <div>
          <h4 class="text-sm font-extrabold text-slate-900 tracking-tight">Relevant Landmark & Contemporary Precedents Identified</h4>
          <span class="text-xs text-slate-600 font-medium">Ranked by factual similarity and judicial holding applicability</span>
        </div>
      </div>
      <span class="text-xs px-3 py-1 rounded-full font-mono font-bold bg-white border border-purple-200 text-purple-900 shadow-xs">
        Filter: ${jurisdictionFilter === 'ALL' ? 'All States (WA, OR, CA, NY)' : jurisdictionFilter}
      </span>
    </div>

    <!-- Precedent Cards List -->
    <div class="space-y-5">
      ${matches.map((c, idx) => `
        <div class="p-6 rounded-3xl bg-white border border-slate-200/90 space-y-5 hover:border-purple-300 transition shadow-sm border-l-4 border-l-purple-600">
          
          <!-- Card Top Bar -->
          <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-2 border-b border-slate-100 pb-3">
            <div class="flex items-center space-x-2.5">
              <span class="w-7 h-7 rounded-xl bg-purple-100 text-purple-900 flex items-center justify-center text-xs font-black font-mono">
                0${idx + 1}
              </span>
              <div>
                <h4 class="text-sm sm:text-base font-extrabold text-slate-900 tracking-tight">${c.title}</h4>
                <span class="text-[11px] text-purple-700 font-semibold font-mono">${c.citation}</span>
              </div>
            </div>
            <div class="flex items-center space-x-2">
              <span class="text-[10px] px-2.5 py-0.5 rounded-full font-bold bg-purple-100 text-purple-800 border border-purple-200">
                ${c.jurisdictionName} (${c.jurisdiction})
              </span>
              <span class="text-[10px] px-2.5 py-0.5 rounded-full font-mono font-bold bg-emerald-100 text-emerald-800 border border-emerald-200">
                ${c.matchScore}% Match
              </span>
            </div>
          </div>

          <!-- Case Facts & Legal Holding -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs">
            <div class="p-4 rounded-2xl bg-slate-50 border border-slate-200 space-y-1.5 border-l-3 border-l-slate-400">
              <strong class="text-slate-900 block text-[10px] uppercase tracking-wider font-black flex items-center gap-1.5">
                <i data-lucide="file-text" class="w-3.5 h-3.5 text-slate-600"></i> Clinical Fact Pattern:
              </strong>
              <p class="text-slate-700 leading-relaxed font-medium">${c.factPattern}</p>
            </div>
            <div class="p-4 rounded-2xl bg-indigo-50/60 border border-indigo-200 space-y-1.5 border-l-3 border-l-indigo-500">
              <strong class="text-indigo-950 block text-[10px] uppercase tracking-wider font-black flex items-center gap-1.5">
                <i data-lucide="gavel" class="w-3.5 h-3.5 text-indigo-700"></i> Judicial Holding & Verdict:
              </strong>
              <p class="text-indigo-950 leading-relaxed font-medium">${c.holding}</p>
              <span class="inline-block mt-1 text-[10px] px-2 py-0.5 rounded font-bold bg-white text-indigo-900 border border-indigo-200">
                Outcome: ${c.verdictOutcome}
              </span>
            </div>
          </div>

          <!-- Standard of Care Defense Strategy -->
          <div class="p-4 rounded-2xl bg-amber-50/70 border border-amber-200 text-xs space-y-1.5 border-l-4 border-l-amber-500">
            <strong class="text-amber-950 block text-[10px] uppercase tracking-wider font-black flex items-center gap-1.5">
              <i data-lucide="shield" class="w-3.5 h-3.5 text-amber-700"></i> Standard of Care Defensive Strategy:
            </strong>
            <p class="text-slate-800 leading-relaxed font-medium">${c.defenseStrategy}</p>
          </div>

          <!-- Defensive Charting Directive (Copy-Ready) -->
          <div class="p-5 rounded-2xl bg-emerald-50/80 border border-emerald-300 text-xs space-y-3 border-l-4 border-l-emerald-600">
            <div class="flex items-center justify-between">
              <div class="flex items-center space-x-2">
                <div class="p-1 rounded-lg bg-emerald-200 text-emerald-900">
                  <i data-lucide="file-pen" class="w-4 h-4 text-emerald-800"></i>
                </div>
                <div>
                  <span class="font-extrabold text-emerald-950 text-xs block tracking-tight">Defensive Charting Directive</span>
                  <span class="text-[10px] text-emerald-700 font-medium">Verbatim phrase to document in clinical EMR records</span>
                </div>
              </div>
              <button class="btn-copy-charting px-3.5 py-1.5 rounded-xl bg-white hover:bg-emerald-100 border border-emerald-300 text-emerald-950 font-bold text-xs transition shadow-xs flex items-center gap-1.5" data-charting="${encodeURIComponent(c.defensiveChartingDirective)}">
                <i data-lucide="copy" class="w-3.5 h-3.5 text-emerald-700"></i>
                <span>Copy Chart Directive</span>
              </button>
            </div>
            <pre class="whitespace-pre-wrap font-sans text-xs text-emerald-950 leading-relaxed bg-white p-3.5 rounded-xl border border-emerald-200 shadow-xs select-all italic font-medium">“${c.defensiveChartingDirective}”</pre>
            <div class="flex items-center justify-between pt-1 text-[11px] text-slate-500">
              <span class="font-mono font-semibold">Statute: ${c.statutoryRef}</span>
              <span class="text-emerald-800 font-bold">Category: ${c.category}</span>
            </div>
          </div>

        </div>
      `).join('')}
    </div>
  `;

  if (typeof window !== 'undefined' && window.lucide) window.lucide.createIcons();

  container.querySelectorAll('.btn-copy-charting').forEach(btn => {
    btn.addEventListener('click', () => {
      const text = decodeURIComponent(btn.getAttribute('data-charting'));
      navigator.clipboard.writeText(text).then(() => {
        btn.innerHTML = `<i data-lucide="check" class="w-3.5 h-3.5 text-emerald-700"></i><span>Copied!</span>`;
        if (window.lucide) window.lucide.createIcons();
        setTimeout(() => {
          btn.innerHTML = `<i data-lucide="copy" class="w-3.5 h-3.5 text-emerald-700"></i><span>Copy Chart Directive</span>`;
          if (window.lucide) window.lucide.createIcons();
        }, 2000);
      });
    });
  });
}

// ==========================================
// 8. STATUTE & PRECEDENT EXPLORER
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
    <div class="p-5 rounded-2xl bg-white border border-slate-200/90 space-y-3 flex flex-col justify-between shadow-xs hover:border-teal-400 transition border-l-4 border-l-teal-600">
      <div class="space-y-2">
        <div class="flex items-center justify-between">
          <span class="text-[10px] px-2.5 py-0.5 rounded-full bg-teal-100 text-teal-800 font-mono font-bold border border-teal-200">${item.code}</span>
          <span class="text-[10px] px-2 py-0.5 rounded-full bg-slate-100 border border-slate-200 text-slate-600 font-bold">${item.type}</span>
        </div>
        <h4 class="text-xs sm:text-sm font-extrabold text-slate-900">${item.title}</h4>
        <p class="text-xs text-slate-600 leading-relaxed font-medium">${item.summary}</p>
      </div>
      <div class="pt-3 border-t border-slate-100 text-xs text-teal-950 font-medium bg-teal-50/50 p-3 rounded-xl border border-teal-100">
        <strong class="text-teal-950 text-[10px] uppercase font-black block tracking-wider mb-0.5">Key Defensive Takeaway:</strong>
        ${item.keyTakeaway}
      </div>
    </div>
  `).join('');

  if (typeof window !== 'undefined' && window.lucide) window.lucide.createIcons();
}

// ==========================================
// 9. AI COPILOT SETUP WITH PHI SANITIZATION
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

  if (q.includes('contract') || q.includes('tail') || q.includes('non-compete') || q.includes('redline')) {
    return `### 📜 Physician Contract Negotiation & Redline Strategy
1. **Tail Insurance Allocation:** Demand that the hospital employer fund 100% of claims-made tail coverage if termination occurs without cause or after 2 years of service.
2. **Strike Geographic Non-Competes:** In Washington (RCW 49.62), replace 25-mile post-employment practice bans with a standard 12-month patient non-solicitation clause.
3. **Emergency Call Coverage Stipends:** Never accept unassigned ED call as 'included in base salary'. Insist on dedicated per diem stipends ($1,500–$3,000/24h) under Stark Law FMV standards.`;
  }

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

  return `### ⚖️ MDEsq Strategic Medicolegal Analysis
Under Washington State Law (RCW 7.70, RCW 18.71, RCW 49.62, RCW 70.41.200):
* **Contract Parity (RCW 49.62):** Restrictive covenants strictly curtailed with statutory damages for employer overreach.
* **Standard of Care (RCW 7.70.040):** Evaluated against an ordinarily prudent health care provider in Washington under similar clinical circumstances.
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
