import Foundation

// MARK: - Legal Precedent Model
struct LegalPrecedent: Identifiable, Hashable {
    let id: String
    let caseName: String
    let citation: String
    let court: String
    let year: Int
    let jurisdiction: String
    let specialty: String
    let category: String
    let verdictOutcome: String
    let holding: String
    let statutoryRef: String
    let keywords: [String]
    let defenseStrategy: String
    let defensiveChartingDirective: String
}

// MARK: - Clinical Scenario Preset
struct PrecedentScenarioPreset: Identifiable, Hashable {
    let id: String
    let label: String
    let icon: String
    let queryText: String
}

// MARK: - Precedent Database
struct PrecedentDatabase {
    static let scenarioPresets: [PrecedentScenarioPreset] = [
        PrecedentScenarioPreset(
            id: "preset-spine-dural",
            label: "Spine Dural Tear / Cauda Equina",
            icon: "figure.walk",
            queryText: "lumbar spine laminectomy dural tear CSF leak cauda equina informed consent"
        ),
        PrecedentScenarioPreset(
            id: "preset-stroke-tpa",
            label: "Delayed Diagnosis / Loss of Chance",
            icon: "brain.head.profile",
            queryText: "missed diagnosis delayed treatment stroke sepsis loss of chance survival"
        ),
        PrecedentScenarioPreset(
            id: "preset-retained-sponge",
            label: "Retained Foreign Body / Count",
            icon: "bandage.fill",
            queryText: "retained surgical sponge laparotomy pad instrument count res ipsa loquitur"
        ),
        PrecedentScenarioPreset(
            id: "preset-noncompete",
            label: "Non-Compete / Hospital Privileges",
            icon: "building.columns.fill",
            queryText: "restrictive covenant non-compete radius peer review summary suspension"
        ),
        PrecedentScenarioPreset(
            id: "preset-refusal",
            label: "Patient Refusal / Informed Refusal",
            icon: "hand.raised.fill",
            queryText: "patient refused diagnostic test screening AMA informed refusal"
        )
    ]

    static let allPrecedents: [LegalPrecedent] = [
        // WASHINGTON STATE LANDMARK & CONTEMPORARY CASES
        LegalPrecedent(
            id: "wa-keen-2023",
            caseName: "Keen v. Sightline Health / MultiCare",
            citation: "530 P.3d 1092 (Wash. Ct. App. 2023)",
            court: "Washington Court of Appeals",
            year: 2023,
            jurisdiction: "WA",
            specialty: "Neurosurgery / Spine",
            category: "Standard of Care & Causation",
            verdictOutcome: "Defense Summary Judgment Affirmed",
            holding: "Under RCW 7.70.040, an adverse surgical outcome (such as a post-operative neurological deficit or incidental durotomy) does not itself establish a breach of the standard of care. A plaintiff must present qualified expert testimony establishing both the specific standard of care in the State of Washington and proximate causation on a 'more probable than not' basis.",
            statutoryRef: "RCW 7.70.040",
            keywords: ["neurosurgery", "spine", "laminectomy", "dural tear", "csf leak", "cauda equina", "complication", "expert", "causation", "deficit"],
            defenseStrategy: "Move for summary judgment under RCW 7.70.040 whenever plaintiff's expert relies on res ipsa loquitur or outcome-based hindsight for a recognized anatomical complication.",
            defensiveChartingDirective: "\"Informed consent obtained after detailed discussion of recognized neurosurgical risks, specifically including incidental durotomy/CSF leak, nerve root injury, epidural hematoma, infection, and persistent neurological deficit. Intraoperative inspection confirmed complete decompression and watertight dural closure via Valsalva maneuver.\""
        ),
        LegalPrecedent(
            id: "wa-davis-2016",
            caseName: "Davis v. Blumenstein",
            citation: "187 Wash. 2d 907, 389 P.3d 571 (2017)",
            court: "Washington Supreme Court",
            year: 2017,
            jurisdiction: "WA",
            specialty: "Orthopedic & Spine Surgery",
            category: "Exercise of Clinical Judgment",
            verdictOutcome: "Defense Jury Instruction Upheld",
            holding: "A physician is not liable for selecting one of two or more alternative courses of treatment or diagnoses if, in arriving at that judgment, the physician exercised reasonable care and skill within the standard of care—even if an adverse result follows.",
            statutoryRef: "WPI 105.08 / RCW 7.70.040",
            keywords: ["judgment", "conservative", "surgery", "fusion", "decompression", "orthopedic", "spine", "alternative", "choice", "treatment"],
            defenseStrategy: "Request Washington Pattern Jury Instruction (WPI 105.08) 'Exercise of Judgment' whenever the clinical dispute centers on choosing conservative vs. operative management or selecting between surgical approaches.",
            defensiveChartingDirective: "\"Clinical decision-making: Weighed alternative diagnostic and therapeutic pathways, including [Option A: conservative management] versus [Option B: surgical decompression/fusion]. Based on current neurological exam and imaging findings, elected [Chosen Option] after shared decision-making with the patient.\""
        ),
        LegalPrecedent(
            id: "wa-mohr-2012",
            caseName: "Mohr v. Grantham",
            citation: "172 Wash. 2d 844, 262 P.3d 490 (2011)",
            court: "Washington Supreme Court",
            year: 2011,
            jurisdiction: "WA",
            specialty: "Emergency Medicine / Vascular / Neurology",
            category: "Loss of Chance Doctrine",
            verdictOutcome: "Plaintiff Cause of Action Recognized",
            holding: "Washington recognizes a cause of action for 'loss of a chance' of a better medical outcome (even when the initial chance of a favorable outcome was less than 50%), calculated proportionally based on expert statistical testimony.",
            statutoryRef: "RCW 7.70.040",
            keywords: ["loss of chance", "stroke", "tpa", "sepsis", "delayed", "missed", "diagnosis", "emergency", "dissection", "deficit", "survival"],
            defenseStrategy: "Attack speculative percentage estimates by requiring plaintiff's expert to cite peer-reviewed epidemiological literature establishing the exact statistical delta between earlier intervention and the actual timeline.",
            defensiveChartingDirective: "\"Time-stamped neurological/clinical assessment at [Time]: Considered differential diagnosis including acute ischemic/vascular event. Documented exact symptom onset time ([Onset Time]) and rationale for immediate diagnostic imaging / contraindications to thrombolytic therapy.\""
        ),
        LegalPrecedent(
            id: "wa-branom-1999",
            caseName: "Branom v. State",
            citation: "94 Wash. App. 964, 974 P.2d 335 (1999)",
            court: "Washington Court of Appeals",
            year: 1999,
            jurisdiction: "WA",
            specialty: "All Surgical & Procedural Specialties",
            category: "Statutory Exclusivity of RCW 7.70",
            verdictOutcome: "Common-Law Claims Dismissed",
            holding: "Chapter 7.70 RCW sweeps away all common-law causes of action for injuries resulting from health care. A plaintiff cannot bypass informed consent requirements under RCW 7.70.050 by pleading common-law battery or emotional distress unless the procedure was completely unauthorized.",
            statutoryRef: "RCW 7.70.010 / RCW 7.70.050",
            keywords: ["informed consent", "battery", "statute", "exclusivity", "authorization", "scope", "surgery", "consent"],
            defenseStrategy: "Move under CR 12(b)(6) to dismiss any non-RCW 7.70 claims (negligent infliction of emotional distress, battery, Consumer Protection Act claims targeting clinical judgment).",
            defensiveChartingDirective: "\"Patient signed statutory written consent pursuant to RCW 7.70.060. Explicitly discussed material risks, recognized complications, reasonable alternatives (including non-operative care), and scope for intraoperative anatomical adjustments if clinically indicated.\""
        ),
        LegalPrecedent(
            id: "wa-berger-2001",
            caseName: "Berger v. Sonneland",
            citation: "144 Wash. 2d 91, 26 P.3d 257 (2001)",
            court: "Washington Supreme Court",
            year: 2001,
            jurisdiction: "WA",
            specialty: "All Medical & Surgical Specialties",
            category: "Unauthorized Disclosure & Informal Attorney Contact",
            verdictOutcome: "Physician Tort Liability under RCW 7.70 Recognized",
            holding: "A physician's unauthorized disclosure of confidential patient health information—even to a former spouse, third party, or opposing lawyer without a valid HIPAA authorization or court order—gives rise to a statutory cause of action for damages under Chapter 7.70 RCW.",
            statutoryRef: "RCW 7.70.030(1) / RCW 70.02.020",
            keywords: ["privacy", "hipaa", "subpoena", "disclosure", "confidentiality", "ex parte", "lawyer", "records"],
            defenseStrategy: "Never engage in informal phone calls or ex parte discussions about a patient with third parties, family members lacking medical POA, or attorneys without a signed RCW 70.02 authorization or valid court order.",
            defensiveChartingDirective: "\"Verified HIPAA / RCW 70.02 authorization on file prior to releasing clinical summary to designated health care surrogate [Name]. Declined informal third-party inquiry pending formal statutory authorization.\""
        ),
        LegalPrecedent(
            id: "us-patrick-burget-1988",
            caseName: "Patrick v. Burget",
            citation: "486 U.S. 94 (1988)",
            court: "United States Supreme Court",
            year: 1988,
            jurisdiction: "WA",
            specialty: "Surgery / Hospital Privileges & Antitrust",
            category: "Sham Peer Review & Economic Competitor Retaliation",
            verdictOutcome: "U.S. Supreme Court Upheld Treble Antitrust Verdict for Surgeon",
            holding: "Hospital peer review proceedings initiated and conducted in bad faith by direct economic competitors to eliminate a rival surgeon from the market are not shielded by state-action immunity and expose the conspirators to federal antitrust liability.",
            statutoryRef: "15 U.S.C. § 1 (Sherman Act) & 42 U.S.C. § 11112",
            keywords: ["non-compete", "peer review", "summary suspension", "privileges", "competitor", "antitrust", "retaliation", "sham", "hospital"],
            defenseStrategy: "Document every instance where voting MEC or ad-hoc peer review committee members share your subspecialty call pool, compete for surgical referrals, or stand to gain your patient panel upon your suspension.",
            defensiveChartingDirective: "\"Formal Administrative Objection: Placed on record that Committee Members [Names] are direct economic competitors in [Subspecialty] within the meaning of 42 U.S.C. § 11112(b)(3)(A)(iii) and Patrick v. Burget, 486 U.S. 94.\""
        ),

        // OREGON CASES
        LegalPrecedent(
            id: "or-gaston-1995",
            caseName: "Gaston v. Parsons",
            citation: "318 Or. 247, 864 P.2d 1319 (1994)",
            court: "Oregon Supreme Court",
            year: 1994,
            jurisdiction: "OR",
            specialty: "Neurosurgery / Spine / Surgery",
            category: "Statute of Limitations & Informed Consent",
            verdictOutcome: "Discovery Rule Clarified",
            holding: "Under ORS 12.110(4), a surgical complication alone does not automatically trigger the 2-year statute of limitations if the surgeon assures the patient the numbness or deficit is temporary; however, informed consent claims require proof that a reasonable patient would have declined surgery if warned of the specific risk.",
            statutoryRef: "ORS 12.110(4) / ORS 677.097",
            keywords: ["oregon", "statute of limitations", "informed consent", "numbness", "deficit", "paralysis", "spine", "discovery"],
            defenseStrategy: "Document objective post-operative discussions clearly rather than offering vague assurances, and prove compliance with ORS 677.097 by documenting both general explanation and the mandatory inquiry into whether the patient wants a more detailed explanation.",
            defensiveChartingDirective: "\"ORS 677.097 Compliance: Explained procedure in general terms, viable alternatives, and material risks. Specifically asked patient if they desired a more detailed explanation; patient confirmed understanding and elected to proceed.\""
        ),
        LegalPrecedent(
            id: "or-smith-2017",
            caseName: "Smith v. Providence Health & Services",
            citation: "361 Or. 456, 393 P.3d 1106 (2017)",
            court: "Oregon Supreme Court",
            year: 2017,
            jurisdiction: "OR",
            specialty: "Emergency Medicine / Neurology",
            category: "Loss of Chance in Oregon",
            verdictOutcome: "Loss of Chance Adopted",
            holding: "Oregon common law recognizes the loss of a substantial chance of a better medical outcome as a cognizable injury when negligent failure to diagnose or treat deprives a patient of a 33% chance of avoiding permanent neurological deficit.",
            statutoryRef: "ORS 677.095",
            keywords: ["oregon", "stroke", "tia", "mri", "loss of chance", "neurology", "emergency", "delayed"],
            defenseStrategy: "Establish strict adherence to community emergency triage protocols under ORS 677.095 and document objective neurological scores (NIHSS) at presentation and discharge.",
            defensiveChartingDirective: "\"Comprehensive neurological examination performed (NIHSS = 0, cranial nerves II-XII intact, motor 5/5 throughout, normal cerebellar/gait testing). Discussed strict return precautions for any recurrent focal neurological symptoms.\""
        ),

        // CALIFORNIA CASES
        LegalPrecedent(
            id: "ca-cobbs-1972",
            caseName: "Cobbs v. Grant",
            citation: "8 Cal. 3d 229, 502 P.2d 1 (1972)",
            court: "California Supreme Court",
            year: 1972,
            jurisdiction: "CA",
            specialty: "General & Specialty Surgery",
            category: "Material Risk Informed Consent Standard",
            verdictOutcome: "Landmark Patient-Centric Disclosure Standard",
            holding: "A surgeon has a duty to disclose all material information—specifically the inherent risks of death, serious bodily harm, or known complications that a reasonable person in the patient's position would consider significant in deciding whether to undergo the procedure.",
            statutoryRef: "Cal. Civ. Code § 1714",
            keywords: ["california", "informed consent", "spleen", "ulcer", "complication", "bleeding", "durotomy", "material risk"],
            defenseStrategy: "Prove objective causation defense: even if a minor risk was omitted, a prudent person in the patient's clinical position (facing progressive myelopathy or intractable pain) would still have consented to the surgery.",
            defensiveChartingDirective: "\"Discussed all risks of death, paralysis, serious bodily harm, re-operation, and procedure-specific complications. Patient verbalized clear understanding that declining surgical intervention carries substantial risk of progressive irreversible deficit.\""
        ),
        LegalPrecedent(
            id: "ca-truman-1980",
            caseName: "Truman v. Thomas",
            citation: "27 Cal. 3d 285, 611 P.2d 902 (1980)",
            court: "California Supreme Court",
            year: 1980,
            jurisdiction: "CA",
            specialty: "Primary Care / Oncology / Surgery",
            category: "Doctrine of Informed Refusal",
            verdictOutcome: "Duty to Disclose Risks of Refusal",
            holding: "When a patient declines a recommended diagnostic test or surgical intervention, the physician has a legal duty ('Informed Refusal') to inform the patient of the material risks of NOT undergoing the recommended test or procedure.",
            statutoryRef: "California Informed Refusal Doctrine",
            keywords: ["refusal", "declined", "ama", "screening", "mri", "biopsy", "cancer", "informed refusal"],
            defenseStrategy: "Never chart 'Patient refused MRI' in isolation. Always document that you explicitly warned the patient of the potentially fatal or permanent consequences of refusing the diagnostic test.",
            defensiveChartingDirective: "\"Informed Refusal: Recommended urgent [Test/Procedure] to rule out [Condition]. Patient declined. Explicitly advised patient that refusing this evaluation risks missed diagnosis, permanent paralysis/disability, or death. Patient demonstrated capacity and maintained refusal.\""
        ),

        // NEW YORK CASES
        LegalPrecedent(
            id: "ny-kambat-1997",
            caseName: "Kambat v. St. Francis Hospital",
            citation: "89 N.Y.2d 489, 678 N.E.2d 456 (1997)",
            court: "New York Court of Appeals",
            year: 1997,
            jurisdiction: "NY",
            specialty: "All Surgical Specialties",
            category: "Res Ipsa Loquitur & Retained Foreign Bodies",
            verdictOutcome: "Res Ipsa Loquitur Permitted for Retained Pad",
            holding: "Where a foreign object (such as a laparotomy pad or surgical sponge) is unintentionally left inside a patient, a lay jury may infer negligence under res ipsa loquitur without expert testimony, shifting the evidentiary burden.",
            statutoryRef: "NY CPLR § 214-a",
            keywords: ["new york", "retained", "sponge", "foreign body", "laparotomy", "instrument count", "res ipsa loquitur", "xray"],
            defenseStrategy: "Maintain strict distinction between an unintended 'foreign object' and an intentional 'fixation device' or hemostatic agent (which is exempt from the foreign-object tolling rule under NY CPLR 214-a), and document independent radiographic verification if counts are discrepant.",
            defensiveChartingDirective: "\"Surgical sponge, sharp, and instrument counts were performed twice and verified as correct by circulating nurse and scrub technologist prior to fascial closure. No non-absorbable packing remained in the surgical field.\""
        ),
        LegalPrecedent(
            id: "ny-orphan-2009",
            caseName: "Orphan v. Pilnik",
            citation: "15 N.Y.3d 907, 940 N.E.2d 555 (2010)",
            court: "New York Court of Appeals",
            year: 2010,
            jurisdiction: "NY",
            specialty: "Surgery / Oncology",
            category: "Public Health Law § 2805-d Informed Consent",
            verdictOutcome: "Defense Summary Judgment Affirmed",
            holding: "Under NY Public Health Law § 2805-d, a signed consent form coupled with the surgeon's testimony of customary risk disclosure shifts the burden to the plaintiff to prove both qualitative insufficiency of disclosure and that a reasonably prudent person would have foregone the operation.",
            statutoryRef: "NY Pub. Health Law § 2805-d",
            keywords: ["new york", "informed consent", "public health law", "2805-d", "summary judgment", "customary practice"],
            defenseStrategy: "Establish your invariable routine habit and custom of pre-operative informed consent counseling, which is admissible in NY to corroborate contemporaneous chart notes.",
            defensiveChartingDirective: "\"Pursuant to NY PHL § 2805-d, reviewed foreseeable risks, benefits, and alternatives in detail in accordance with standard pre-operative protocol. Patient had full opportunity to ask questions and executed written consent.\""
        )
    ]
}
