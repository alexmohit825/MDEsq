import Foundation

public struct ShamFactor: Identifiable, Hashable {
    public let id: String
    public let name: String
    public let weight: Int
    public let description: String
    public let badFaithIndicator: String
    
    public init(id: String, name: String, weight: Int, description: String, badFaithIndicator: String) {
        self.id = id
        self.name = name
        self.weight = weight
        self.description = description
        self.badFaithIndicator = badFaithIndicator
    }
}

public struct PeerReviewDatabase {
    public static let shamFactors: [ShamFactor] = [
        ShamFactor(
            id: "factor-whistleblower",
            name: "Prior Quality / Patient Safety Whistleblowing",
            weight: 15,
            description: "Targeted physician recently raised formal concerns regarding hospital staffing, equipment defects, or administration overreach.",
            badFaithIndicator: "Retaliatory timing: Peer review initiated within 90 days of safety report."
        ),
        ShamFactor(
            id: "factor-competitor-bias",
            name: "Direct Economic Competitors on Review Panel",
            weight: 15,
            description: "Committee members share the same surgical subspecialty, practice in the same market, or stand to absorb the targeted physician's patient volume.",
            badFaithIndicator: "Clear economic conflict of interest violating HCQIA 42 U.S.C. § 11112 impartiality mandate."
        ),
        ShamFactor(
            id: "factor-procedural-bypass",
            name: "Hospital Medical Staff Bylaw Bypasses",
            weight: 10,
            description: "Administration bypassed informal review, failed to provide written notice of charges, or skipped department chair investigation.",
            badFaithIndicator: "Violation of physician's procedural due process rights."
        ),
        ShamFactor(
            id: "factor-record-denial",
            name: "Denial of Chart & EMR Audit Trail Access",
            weight: 10,
            description: "Targeted physician was locked out of EMR charts, preventing preparation of clinical defenses.",
            badFaithIndicator: "Constructive denial of right to fair hearing."
        ),
        ShamFactor(
            id: "factor-expert-refusal",
            name: "Refusal to Permit Independent External Academic Review",
            weight: 10,
            description: "Administration refused physician's request for blind out-of-state academic subspecialist review.",
            badFaithIndicator: "Suppression of exculpatory subspecialty standard of care evidence."
        )
    ]
}
