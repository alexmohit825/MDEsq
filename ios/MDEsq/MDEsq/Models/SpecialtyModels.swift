import Foundation

public struct SpecialtyBenchmark: Identifiable, Hashable {
    public let id: String
    public let name: String
    public let category: String
    public let compP25: Double
    public let compP50: Double
    public let compP75: Double
    public let compP90: Double
    public let wrvuP50: Double
    public let wrvuP75: Double
    public let wrvuP90: Double
    public let convFactorP50: Double
    public let callStipend24h: Double
    
    public init(id: String, name: String, category: String, compP25: Double, compP50: Double, compP75: Double, compP90: Double, wrvuP50: Double, wrvuP75: Double, wrvuP90: Double, convFactorP50: Double, callStipend24h: Double) {
        self.id = id
        self.name = name
        self.category = category
        self.compP25 = compP25
        self.compP50 = compP50
        self.compP75 = compP75
        self.compP90 = compP90
        self.wrvuP50 = wrvuP50
        self.wrvuP75 = wrvuP75
        self.wrvuP90 = wrvuP90
        self.convFactorP50 = convFactorP50
        self.callStipend24h = callStipend24h
    }
}

public struct SpecialtyDatabase {
    public static let allBenchmarks: [SpecialtyBenchmark] = [
        SpecialtyBenchmark(
            id: "neurosurgery-spine",
            name: "Neurosurgery (Spine / Complex)",
            category: "Surgical Subspecialty",
            compP25: 720000,
            compP50: 890000,
            compP75: 1150000,
            compP90: 1420000,
            wrvuP50: 9400,
            wrvuP75: 12200,
            wrvuP90: 15400,
            convFactorP50: 94.50,
            callStipend24h: 2500
        ),
        SpecialtyBenchmark(
            id: "orthopedic-spine",
            name: "Orthopedic Surgery (Spine)",
            category: "Surgical Subspecialty",
            compP25: 690000,
            compP50: 860000,
            compP75: 1120000,
            compP90: 1380000,
            wrvuP50: 9100,
            wrvuP75: 11900,
            wrvuP90: 14900,
            convFactorP50: 92.00,
            callStipend24h: 2250
        ),
        SpecialtyBenchmark(
            id: "orthopedic-joints",
            name: "Orthopedic Surgery (General / Joints)",
            category: "Surgical Subspecialty",
            compP25: 560000,
            compP50: 695000,
            compP75: 880000,
            compP90: 1080000,
            wrvuP50: 8600,
            wrvuP75: 11000,
            wrvuP90: 13800,
            convFactorP50: 81.00,
            callStipend24h: 1800
        ),
        SpecialtyBenchmark(
            id: "cardiology-interventional",
            name: "Cardiology (Interventional)",
            category: "Medical Subspecialty",
            compP25: 580000,
            compP50: 710000,
            compP75: 890000,
            compP90: 1090000,
            wrvuP50: 9200,
            wrvuP75: 11800,
            wrvuP90: 14500,
            convFactorP50: 77.00,
            callStipend24h: 1750
        ),
        SpecialtyBenchmark(
            id: "anesthesiology",
            name: "Anesthesiology (General / Cardiac)",
            category: "Hospital-Based",
            compP25: 410000,
            compP50: 495000,
            compP75: 585000,
            compP90: 680000,
            wrvuP50: 0,
            wrvuP75: 0,
            wrvuP90: 0,
            convFactorP50: 0,
            callStipend24h: 1500
        ),
        SpecialtyBenchmark(
            id: "radiology-diagnostic",
            name: "Radiology (Diagnostic)",
            category: "Hospital-Based",
            compP25: 460000,
            compP50: 560000,
            compP75: 675000,
            compP90: 790000,
            wrvuP50: 10200,
            wrvuP75: 12800,
            wrvuP90: 15600,
            convFactorP50: 55.00,
            callStipend24h: 1400
        ),
        SpecialtyBenchmark(
            id: "general-surgery",
            name: "General Surgery",
            category: "Surgical",
            compP25: 410000,
            compP50: 495000,
            compP75: 610000,
            compP90: 730000,
            wrvuP50: 7200,
            wrvuP75: 9100,
            wrvuP90: 11500,
            convFactorP50: 68.00,
            callStipend24h: 1500
        ),
        SpecialtyBenchmark(
            id: "internal-medicine",
            name: "Internal Medicine (Outpatient)",
            category: "Primary Care",
            compP25: 240000,
            compP50: 290000,
            compP75: 350000,
            compP90: 415000,
            wrvuP50: 4800,
            wrvuP75: 6100,
            wrvuP90: 7600,
            convFactorP50: 59.00,
            callStipend24h: 600
        )
    ]
}
