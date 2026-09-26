/**
 * MDEsq - Main Application Controller
 * High-performance, zero-dependency ES Module
 */

import { JURISDICTIONS, FEDERAL_REGULATIONS } from './data/statutes.js';
import { SPECIALTY_BENCHMARKS } from './data/specialties.js';

// Application State
const state = {
  currentJurisdiction: 'WA',
  currentTab: 'tab-fmv-contracts',
  selectedSpecialtyId: 'neurosurgery-spine',
  auditAnswers: {},
  apiKey: (typeof localStorage !== 'undefined' && localStorage.getItem('mdesq_gemini_key')) || '',
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
    // Scrub Medical Record Numbers (MRN)
    .replace(/\b(MRN|mrn|ID|id|record\s*#?)\s*[:#]?\s*\d{4,12}\b/gi, '[MRN-REDACTED]')
    // Scrub Social Security Numbers
    .replace(/\b\d{3}[-]?\d{2}[-]?\d{4}\b/g, '[SSN-REDACTED]')
    // Scrub Phone Numbers
    .replace(/\b(?:\+?1[-.\s]?)?\(?\d{3}\)?[-.\s]?\d{3}[-.\s]?\d{4}\b/g, '[PHONE-REDACTED]')
    // Scrub Email Addresses
    .replace(/\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b/g, '[EMAIL-REDACTED]')
    // Scrub specific dates of service (replace with generalized format)
    .replace(/\b\d{1,2}[\/\.-]\d{1,2}[\/\.-]\d{2,4}\b/g, '[DATE-REDACTED]')
    // Scrub specific patient name patterns (e.g., "Patient John Doe", "Mr. Smith")
    .replace(/\b(Patient|pt|Mr\.|Ms\.|Mrs\.)\s+([A-Z][a-z]+)(\s+[A-Z][a-z]+)?\b/g, '[PATIENT-NAME-REDACTED]');
}

// Compensation & FMV Calculator Logic
export function calculateFMVMetrics(specialtyId, baseSalary, targetWrvus, convFactor, callDays) {
  const spec = SPECIALTY_BENCHMARKS.find(s => s.id === specialtyId) || SPECIALTY_BENCHMARKS[0];
  const calculatedProductionComp = targetWrvus * convFactor;
  const totalEstimatedComp = Math.max(baseSalary, calculatedProductionComp);

  let fmvStatus = 'standard';
  let statusTitle = 'Standard FMV Range';
  let statusClass = 'emerald';
  let statusDesc = '';

  if (totalEstimatedComp < spec.compP25) {
    fmvStatus = 'undercompensated';
    statusTitle = 'Below 25th Percentile (Severe Undercompensation)';
    statusClass = 'amber';
    statusDesc = `Your compensation package ($${totalEstimatedComp.toLocaleString()}) is below the 25th national percentile for ${spec.name} ($${spec.compP25.toLocaleString()}). You have substantial leverage to negotiate a higher base salary or increased $/wRVU conversion rate.`;
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

// Initialization & DOM Binding
if (typeof document !== 'undefined') {
  document.addEventListener('DOMContentLoaded', () => {
    // Initialize Lucide icons
    if (typeof window !== 'undefined' && window.lucide) {
      window.lucide.createIcons();
    }

    initNavigation();
    initJurisdictionSelector();
    initFMVCalculator();
    initRiskAudit();
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

      // Update tab styles
      tabs.forEach(t => {
        t.classList.remove('active-tab', 'text-brand-400', 'bg-brand-500/10', 'border-brand-500/20');
        t.classList.add('text-slate-400');
      });
      tab.classList.add('active-tab', 'text-brand-400', 'bg-brand-500/10', 'border-brand-500/20');
      tab.classList.remove('text-slate-400');

      // Show target panel
      document.querySelectorAll('.tab-panel').forEach(p => p.classList.add('hidden'));
      const targetPanel = document.getElementById(targetTabId);
      if (targetPanel) {
        targetPanel.classList.remove('hidden');
      }

      if (window.lucide) window.lucide.createIcons();
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

  // Refresh statutes list
  renderStatutes();
}

// FMV Calculator Setup
function initFMVCalculator() {
  const select = document.getElementById('fmv-specialty-select');
  if (!select) return;

  // Populate options
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

  // Attach input listeners
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

  // Update Percentile Numbers
  document.getElementById('disp-p25-comp').textContent = `$${(spec.compP25 / 1000).toFixed(0)}k`;
  document.getElementById('disp-p25-wrvu').textContent = `${spec.wRVUP25.toLocaleString()} wRVUs`;

  document.getElementById('disp-p50-comp').textContent = `$${(spec.compP50 / 1000).toFixed(0)}k`;
  document.getElementById('disp-p50-wrvu').textContent = `${spec.wRVUP50.toLocaleString()} wRVUs`;

  document.getElementById('disp-p75-comp').textContent = `$${(spec.compP75 / 1000).toFixed(0)}k`;
  document.getElementById('disp-p75-wrvu').textContent = `${spec.wRVUP75.toLocaleString()} wRVUs`;

  document.getElementById('disp-p90-comp').textContent = `$${(spec.compP90 / 1000).toFixed(0)}k`;
  document.getElementById('disp-p90-wrvu').textContent = `${spec.wRVUP90.toLocaleString()} wRVUs`;

  // Update Status Box
  const statusTitle = document.getElementById('fmv-status-title');
  const statusDesc = document.getElementById('fmv-status-description');
  const statusPill = document.getElementById('fmv-status-pill');

  if (statusTitle) statusTitle.textContent = res.statusTitle;
  if (statusDesc) statusDesc.textContent = res.statusDesc;
  if (statusPill) {
    statusPill.textContent = res.statusTitle.split('(')[0].trim();
    statusPill.className = `text-[10px] px-2 py-0.5 rounded-full font-semibold bg-${res.statusClass}-500/10 text-${res.statusClass}-400 border border-${res.statusClass}-500/20`;
  }
}

// Medicolegal Risk Audit Setup
function initRiskAudit() {
  const container = document.getElementById('risk-questions-container');
  if (!container) return;

  // Render questions
  container.innerHTML = RISK_QUESTIONS.map((q, qIndex) => `
    <div class="p-4 rounded-xl bg-slate-900/90 border border-slate-800 space-y-3" id="card-${q.id}">
      <div class="flex items-center justify-between">
        <h4 class="text-xs font-bold text-white flex items-center gap-2">
          ${q.title}
        </h4>
        <span class="text-[10px] px-2 py-0.5 rounded bg-slate-800 text-slate-400 font-mono">${q.statute}</span>
      </div>
      <p class="text-xs text-slate-300">${q.question}</p>
      <div class="grid grid-cols-1 gap-2 pt-1">
        ${q.options.map((opt, optIndex) => `
          <label class="flex items-start space-x-2.5 p-2.5 rounded-lg border border-slate-800 hover:bg-slate-800/60 cursor-pointer transition text-xs text-slate-300">
            <input type="radio" name="${q.id}" value="${optIndex}" class="mt-0.5 text-brand-500 focus:ring-brand-500" ${state.auditAnswers[q.id] === optIndex ? 'checked' : ''}>
            <span class="leading-relaxed">${opt.text}</span>
          </label>
        `).join('')}
      </div>
    </div>
  `).join('');

  // Attach change listener
  container.addEventListener('change', (e) => {
    if (e.target.type === 'radio') {
      state.auditAnswers[e.target.name] = parseInt(e.target.value, 10);
      updateRiskAuditResults();
    }
  });

  // Reset button
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
    badge.className = `px-3.5 py-1.5 rounded-xl bg-${res.badgeColor}-500/10 border border-${res.badgeColor}-500/30 text-${res.badgeColor}-400 font-mono font-bold text-sm`;
  }

  const tierLabel = document.getElementById('mvi-tier-label');
  if (tierLabel) {
    tierLabel.textContent = res.tierLabel;
    tierLabel.className = `text-xs font-semibold px-2.5 py-0.5 rounded-full bg-${res.badgeColor}-500/10 text-${res.badgeColor}-400 border border-${res.badgeColor}-500/20`;
  }

  const narrative = document.getElementById('mvi-tier-narrative');
  if (narrative) narrative.textContent = res.tierNarrative;

  const recsContainer = document.getElementById('mvi-recs-container');
  if (recsContainer) {
    if (res.criticalDeficiencies.length === 0) {
      recsContainer.innerHTML = `
        <div class="p-3 rounded-lg bg-emerald-500/10 border border-emerald-500/20 text-xs text-emerald-300">
          ✅ Zero high-exposure vulnerabilities logged. Continue contemporaneous operative reporting and closed-loop test tracking.
        </div>
      `;
    } else {
      recsContainer.innerHTML = `
        <div class="space-y-1.5">
          <span class="text-[11px] font-bold text-rose-400 uppercase tracking-wider block">Priority Defensive Corrective Actions:</span>
          ${res.criticalDeficiencies.map(d => `
            <div class="p-2.5 rounded-lg bg-rose-500/10 border border-rose-500/20 text-xs text-rose-200 flex items-start gap-2">
              <i data-lucide="alert-circle" class="w-4 h-4 text-rose-400 flex-shrink-0 mt-0.5"></i>
              <div>
                <strong>${d.question} (${d.statute}):</strong>
                <p class="text-slate-300 mt-0.5">Deficiency logged: "${d.selectedText.substring(0, 90)}...". Mandate explicit charting before hospital record closure.</p>
              </div>
            </div>
          `).join('')}
        </div>
      `;
      if (window.lucide) window.lucide.createIcons();
    }
  }
}

// Statute & Case Law Explorer Setup
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
    <div class="p-4 rounded-xl bg-slate-900/90 border border-slate-800 space-y-2.5 flex flex-col justify-between">
      <div class="space-y-1.5">
        <div class="flex items-center justify-between">
          <span class="text-[10px] px-2 py-0.5 rounded bg-slate-800 text-brand-400 font-mono font-semibold">${item.code}</span>
          <span class="text-[10px] px-2 py-0.5 rounded bg-slate-800 text-slate-400">${item.type}</span>
        </div>
        <h4 class="text-xs font-bold text-white">${item.title}</h4>
        <p class="text-xs text-slate-300 leading-relaxed">${item.summary}</p>
      </div>
      <div class="pt-2 border-t border-slate-800 text-xs text-brand-300/90">
        <strong class="text-white text-[11px] block">Key Defensive Takeaway:</strong>
        ${item.keyTakeaway}
      </div>
    </div>
  `).join('');
}

// AI Copilot Setup with PHI Sanitization
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

    // Append User Message to UI
    appendChatMessage('user', query);

    // Sanitize PHI
    const sanitizedQuery = sanitizePHI(query);

    // Show Typing Indicator
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
You provide sharp, legally grounded, practical advice regarding hospital contract negotiations, Fair Market Value (FMV), Stark Law, non-competes, medical malpractice standard of care defense, and medical board investigations.
Always maintain a direct, professional, protective tone for the physician.
Include statutory citations (RCW/WAC/Stark) where relevant. Include a brief educational disclaimer.`;

  // 1. If direct API key is stored locally in settings, use Google Gemini API directly
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

  // 2. Otherwise route via Cloudflare Pages Function proxy (/api/chat)
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
    // If running purely offline/locally without backend proxy or API key, provide smart rule-based response
    return generateOfflineMedicolegalResponse(sanitizedPrompt);
  }
}

// Smart Offline Fallback Engine for immediate demonstration
function generateOfflineMedicolegalResponse(query) {
  const q = query.toLowerCase();

  if (q.includes('board') || q.includes('wmc') || q.includes('complaint') || q.includes('investigation')) {
    return `### 🛡️ Washington Medical Commission (WMC) Defense Guidance
1. **Do NOT Respond Unrepresented:** Under RCW 18.130 (Uniform Disciplinary Act), your initial written response becomes part of the permanent record. Contact your malpractice carrier to assign health law counsel immediately.
2. **Obtain the Complete Certified Record:** Never rely on memory. Demand the complete medical record, nursing notes, and EMR audit trail before writing a response.
3. **Stipulation to Informal Disposition (STID):** If allegations have merit, seek a non-disciplinary STID under RCW 18.130.172 to prevent mandatory reporting to the National Practitioner Data Bank (NPDB).`;
  }

  if (q.includes('non-compete') || q.includes('restrictive covenant') || q.includes('radius')) {
    return `### 📜 Washington Non-Compete Law (RCW 49.62)
1. **Statutory Salary Floor:** In Washington, non-compete agreements are void against employees earning less than the statutory inflation-adjusted threshold (approx. $120,559+/yr).
2. **18-Month Presumption Ceiling:** Any covenant exceeding 18 months post-termination is rebuttably presumed unreasonable and unenforceable.
3. **Mandatory Attorney Fees (RCW 49.62.080):** If an employer attempts to enforce an unlawful non-compete against you, the court *must* award statutory damages plus your reasonable attorney fees.`;
  }

  if (q.includes('fmv') || q.includes('stark') || q.includes('salary') || q.includes('wrvu') || q.includes('compensation')) {
    return `### 💰 Fair Market Value (FMV) & Stark Law (42 U.S.C. § 1395nn)
1. **Commercial Reasonableness:** Compensation must reflect FMV for clinical services rendered, without regard to volume or value of hospital admissions or downstream referrals.
2. **Safe Corridor (25th–75th Percentile):** Compensation aligned with median MGMA/AMGA benchmark $/wRVU conversion factors represents the safest regulatory tier.
3. **Call Coverage:** Ensure all 24-hour unassigned ED call shifts receive dedicated stipends separate from the clinical wRVU base threshold.`;
  }

  return `### ⚖️ MDEsq Strategic Medicolegal Analysis
Under Washington State Law (RCW 7.70 & RCW 18.71):
* **Standard of Care (RCW 7.70.040):** Standard of care is evaluated based on what an ordinarily prudent healthcare provider in the same field in Washington would do under similar circumstances.
* **Informed Consent (RCW 7.70.050):** Always ensure contemporaneous documentation of specific material surgical risks, alternative medical modalities, and patient choice.
* **Privileged Peer Review (RCW 70.41.200):** Maintain all quality reviews and complication discussions within formal QA channels, never in the discoverable patient chart.`;
}

function appendChatMessage(role, text) {
  const container = document.getElementById('ai-chat-messages');
  if (!container) return;

  const isUser = role === 'user';
  const div = document.createElement('div');
  div.className = `flex items-start space-x-3 ${isUser ? 'justify-end' : ''}`;

  if (isUser) {
    div.innerHTML = `
      <div class="p-3.5 rounded-2xl rounded-tr-none bg-brand-600 text-white max-w-xl text-xs leading-relaxed shadow">
        ${escapeHtml(text)}
      </div>
      <div class="w-8 h-8 rounded-lg bg-slate-800 border border-slate-700 flex items-center justify-center text-slate-300 flex-shrink-0 font-bold text-xs">
        MD
      </div>
    `;
  } else {
    div.innerHTML = `
      <div class="w-8 h-8 rounded-lg bg-brand-600 flex items-center justify-center text-white flex-shrink-0 font-bold text-xs">
        ESQ
      </div>
      <div class="p-3.5 rounded-2xl rounded-tl-none bg-slate-900 border border-slate-800 text-slate-200 max-w-2xl text-xs space-y-2 leading-relaxed">
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
    <div class="w-8 h-8 rounded-lg bg-brand-600 flex items-center justify-center text-white flex-shrink-0 font-bold text-xs">
      ESQ
    </div>
    <div class="p-3 rounded-2xl rounded-tl-none bg-slate-900 border border-slate-800 text-slate-400 text-xs flex items-center space-x-1.5">
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
    .replace(/### (.*?)\n/g, '<h4 class="text-xs font-bold text-white mt-2 mb-1">$1</h4>')
    .replace(/\*\*(.*?)\*\*/g, '<strong class="text-white font-semibold">$1</strong>')
    .replace(/\*(.*?)\*/g, '<em class="text-slate-300">$1</em>')
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
