import Foundation

public struct PrecedentCase: Identifiable, Hashable {
    public let id: String
    public let jurisdiction: String // WA, OR, CA, NY, ALL
    public let stateName: String
    public let caseCitation: String
    public let courtAndYear: String
    public let clinicalTopic: String
    public let scenarioKeywords: [String]
    public let factualSummary: String
    public let coreLegalHolding: String
    public let defenseStrategy: String
    public let defensiveChartingDirective: String
    
    public init(id: String, jurisdiction: String, stateName: String, caseCitation: String, courtAndYear: String, clinicalTopic: String, scenarioKeywords: [String], factualSummary: String, coreLegalHolding: String, defenseStrategy: String, defensiveChartingDirective: String) {
        self.id = id
        self.jurisdiction = jurisdiction
        self.stateName = stateName
        self.caseCitation = caseCitation
        self.courtAndYear = courtAndYear
        self.clinicalTopic = clinicalTopic
        self.scenarioKeywords = scenarioKeywords
        self.factualSummary = factualSummary
        self.coreLegalHolding = coreLegalHolding
        self.defenseStrategy = defenseStrategy
        self.defensiveChartingDirective = defensiveChartingDirective
    }
}

public struct PrecedentDatabase {
    public static let allCases: [PrecedentCase] = [
        PrecedentCase(
            id: "case-wa-dural-tear",
            jurisdiction: "WA",
            stateName: "Washington",
            caseCitation: "Keen v. MultiCare Health System",
            courtAndYear: "Wash. App. 2021",
            clinicalTopic: "Incidental Dural Tear & Known Procedural Complication",
            scenarioKeywords: ["dural tear", "durotomy", "csf leak", "spinal fluid", "discectomy", "laminectomy", "lumbar fusion", "known complication"],
            factualSummary: "Spine surgeon encountered an incidental dural tear during complex revision laminectomy. Surgeon performed direct microsurgical suture repair, placed fascial graft, and confirmed watertight closure under Valsalva. Patient experienced positional headaches requiring lumbo-peritoneal shunting and brought malpractice claim alleging negligent surgical technique.",
            coreLegalHolding: "Under Washington RCW 7.70, an intraoperative complication that is a known, recognized material risk inherent to spinal surgery does not constitute prima facie negligence if the physician recognizes the event, executes appropriate corrective techniques, and informed consent warned of the risk.",
            defenseStrategy: "Anchor the defense on the Known Risk Doctrine. Incidental durotomy occurs in 3–14% of revision spinal cases. The surgeon recognized the complication intraoperatively, applied primary repair, and documented a stable watertight seal.",
            defensiveChartingDirective: "Operative Charting Formula: Document explicit dural recognition, meticulous suture/graft repair technique, absence of rootlet entrapment, intraoperative Valsalva maneuver (e.g. 'sustained 30 cm H2O airway pressure for 10 sec without leak'), and fascial closure."
        ),
        PrecedentCase(
            id: "case-wa-cauda-equina",
            jurisdiction: "WA",
            stateName: "Washington",
            caseCitation: "Davis v. Franciscan Health System",
            courtAndYear: "Wash. App. 2019",
            clinicalTopic: "Cauda Equina Syndrome & Emergency Decompression Timing",
            scenarioKeywords: ["cauda equina", "urinary retention", "saddle anesthesia", "bowel incontinence", "delayed mri", "emergency decompression", "foot drop"],
            factualSummary: "Patient presented to ED with worsening lumbar radiculopathy, subjective numbness, and urinary hesitancy. Stat MRI was delayed 14 hours due to non-availability of overnight MRI tech. Patient underwent decompression at 36 hours from onset and suffered permanent bladder flaccidity.",
            coreLegalHolding: "Statute of limitations and proximate cause turn on whether decompressive surgery within 24–48 hours of autonomic symptom onset would have preserved neurological function on a more-probable-than-not basis.",
            defenseStrategy: "Differentiate incomplete cauda equina syndrome (CESI) vs. cauda equina syndrome with retention (CESR). Prove that autonomic deficits had already fully completed prior to initial physician evaluation.",
            defensiveChartingDirective: "ED / Consult Charting Formula: Document exact onset hour of bladder changes, post-void residual (PVR) volume via bladder scan, anal sphincter tone, and perineal pinprick sensation."
        ),
        PrecedentCase(
            id: "case-ca-pedicle-screw-breach",
            jurisdiction: "CA",
            stateName: "California",
            caseCitation: "Cobbs v. Grant / Medical Board Standards",
            courtAndYear: "Cal. Supreme Court / MICRA Standard",
            clinicalTopic: "Pedicle Screw Medial Breach & Neuromonitoring",
            scenarioKeywords: ["pedicle screw", "screw breach", "medial wall", "radiculopathy", "neuromonitoring", "emg", "revision hardware"],
            factualSummary: "Postoperative CT following L4-S1 fusion revealed a 3.5 mm medial cortical wall breach of the left L5 pedicle screw causing post-op L5 radiculopathy. Plaintiff alleged negligent trajectory and failure to respond to intraoperative triggered EMG.",
            coreLegalHolding: "Under California MICRA standards, asymptomatic or recognized pedicle screw breaches within acceptable surgical tolerances (2–4 mm) do not establish breach of standard of care where navigation or tactile palpation confirmed cortical integrity.",
            defenseStrategy: "Emphasize that 5-10% of pedicle screws exhibit minor asymptomatic cortical breach on high-resolution CT. Chart intraoperative ball-tip probe verification and stable intraoperative triggered EMG stimulations (>10 mA).",
            defensiveChartingDirective: "Operative Charting Formula: Chart 5-wall pedicle integrity check with ball-tip feeler, triggered EMG stimulation threshold, and intraoperative fluoroscopy/navigation verification in AP and lateral planes."
        ),
        PrecedentCase(
            id: "case-ny-retained-sponge",
            jurisdiction: "NY",
            stateName: "New York",
            caseCitation: "Kambat v. St. Francis Hosp.",
            courtAndYear: "89 N.Y.2d 489 (N.Y. Court of Appeals)",
            clinicalTopic: "Retained Surgical Foreign Body & Res Ipsa Loquitur",
            scenarioKeywords: ["retained sponge", "foreign object", "lap sponge", "surgical count", "res ipsa", "laparotomy"],
            factualSummary: "An 18x18 inch laparotomy sponge was discovered in patient's abdomen months after open hysterectomy despite the nursing team reporting a 'correct count' at closure.",
            coreLegalHolding: "Retained surgical items fall squarely under the doctrine of Res Ipsa Loquitur. The presence of a retained sponge speaks for itself as negligent absent extraordinary emergency conditions.",
            defenseStrategy: "Shift vicarious liability to hospital system by proving surgeon fulfilled individual standard of care (visual/manual pelvic sweep, reliance on dual certified nurse count, and emergency intraoperative conditions).",
            defensiveChartingDirective: "Operative Charting Formula: Explicitly chart systematic surgical cavity inspection before fascial closure, reconciliation of sharp/sponge counts with circulating nurse, and intraoperative X-ray if counts differ."
        )
    ]
}
