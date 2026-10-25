import Foundation

public struct SpecialtyBenchmark: Identifiable, Hashable {
    public let id: String
    public let name: String
    public let category: String
    public let compP25: Double
    public let compP50: Double
    public let compP75: Double
    public let compP90: Double
    public let wrvuP25: Double
    public let wrvuP50: Double
    public let wrvuP75: Double
    public let wrvuP90: Double
    public let convFactorP50: Double
    public let convFactorRange: String
    public let callStipend24h: Double
    public let callStipendRange: String
    public let starkRiskThreshold: Double
    
    // Computed property aliases for FMV Calculator & Stark Analysis
    public var conversionFactorMedian: Double { convFactorP50 }
    public var conversionFactorLow: Double { (convFactorP50 * 0.88).rounded() }
    public var conversionFactorHigh: Double { (convFactorP50 * 1.16).rounded() }
    public var callStipend24hMedian: Int { Int(callStipend24h) }
    public var starkHighRiskThreshold: Int { Int(starkRiskThreshold) }
    
    public init(
        id: String,
        name: String,
        category: String,
        compP25: Double,
        compP50: Double,
        compP75: Double,
        compP90: Double,
        wrvuP25: Double,
        wrvuP50: Double,
        wrvuP75: Double,
        wrvuP90: Double,
        convFactorP50: Double,
        convFactorRange: String,
        callStipend24h: Double,
        callStipendRange: String,
        starkRiskThreshold: Double
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.compP25 = compP25
        self.compP50 = compP50
        self.compP75 = compP75
        self.compP90 = compP90
        self.wrvuP25 = wrvuP25
        self.wrvuP50 = wrvuP50
        self.wrvuP75 = wrvuP75
        self.wrvuP90 = wrvuP90
        self.convFactorP50 = convFactorP50
        self.convFactorRange = convFactorRange
        self.callStipend24h = callStipend24h
        self.callStipendRange = callStipendRange
        self.starkRiskThreshold = starkRiskThreshold
    }
}

public struct SpecialtyDatabase {
    public static var allSpecialties: [SpecialtyBenchmark] { allBenchmarks }
    public static let allBenchmarks: [SpecialtyBenchmark] = [
        SpecialtyBenchmark(
            id: "neurosurgery-spine",
            name: "Neurosurgery (Spine / Cranial)",
            category: "Surgical Subspecialty",
            compP25: 690000,
            compP50: 875000,
            compP75: 1120000,
            compP90: 1350000,
            wrvuP25: 7200,
            wrvuP50: 9500,
            wrvuP75: 12400,
            wrvuP90: 15600,
            convFactorP50: 92.50,
            convFactorRange: "$84.00 – $108.00",
            callStipend24h: 2500,
            callStipendRange: "$1,800 – $3,500 / 24h",
            starkRiskThreshold: 1200000
        ),
        SpecialtyBenchmark(
            id: "ortho-spine",
            name: "Orthopedic Surgery (Spine)",
            category: "Surgical Subspecialty",
            compP25: 670000,
            compP50: 850000,
            compP75: 1090000,
            compP90: 1320000,
            wrvuP25: 7100,
            wrvuP50: 9300,
            wrvuP75: 12100,
            wrvuP90: 15200,
            convFactorP50: 91.00,
            convFactorRange: "$82.00 – $105.00",
            callStipend24h: 2250,
            callStipendRange: "$1,600 – $3,200 / 24h",
            starkRiskThreshold: 1180000
        ),
        SpecialtyBenchmark(
            id: "ortho-general",
            name: "Orthopedic Surgery (General / Total Joint)",
            category: "Surgical Subspecialty",
            compP25: 540000,
            compP50: 685000,
            compP75: 860000,
            compP90: 1040000,
            wrvuP25: 6500,
            wrvuP50: 8600,
            wrvuP75: 11000,
            wrvuP90: 13800,
            convFactorP50: 79.50,
            convFactorRange: "$72.00 – $92.00",
            callStipend24h: 1800,
            callStipendRange: "$1,400 – $2,500 / 24h",
            starkRiskThreshold: 950000
        ),
        SpecialtyBenchmark(
            id: "cardiothoracic-surgery",
            name: "Cardiothoracic Surgery",
            category: "Surgical Subspecialty",
            compP25: 610000,
            compP50: 790000,
            compP75: 1020000,
            compP90: 1250000,
            wrvuP25: 6800,
            wrvuP50: 8900,
            wrvuP75: 11600,
            wrvuP90: 14500,
            convFactorP50: 88.00,
            convFactorRange: "$78.00 – $102.00",
            callStipend24h: 2200,
            callStipendRange: "$1,500 – $3,000 / 24h",
            starkRiskThreshold: 1100000
        ),
        SpecialtyBenchmark(
            id: "vascular-surgery",
            name: "Vascular Surgery",
            category: "Surgical Subspecialty",
            compP25: 460000,
            compP50: 580000,
            compP75: 725000,
            compP90: 890000,
            wrvuP25: 6200,
            wrvuP50: 8100,
            wrvuP75: 10300,
            wrvuP90: 12900,
            convFactorP50: 71.50,
            convFactorRange: "$64.00 – $82.00",
            callStipend24h: 1650,
            callStipendRange: "$1,200 – $2,200 / 24h",
            starkRiskThreshold: 800000
        ),
        SpecialtyBenchmark(
            id: "urology",
            name: "Urology",
            category: "Surgical Subspecialty",
            compP25: 430000,
            compP50: 540000,
            compP75: 665000,
            compP90: 815000,
            wrvuP25: 6000,
            wrvuP50: 7700,
            wrvuP75: 9700,
            wrvuP90: 12100,
            convFactorP50: 70.00,
            convFactorRange: "$62.00 – $79.00",
            callStipend24h: 1250,
            callStipendRange: "$900 – $1,600 / 24h",
            starkRiskThreshold: 750000
        ),
        SpecialtyBenchmark(
            id: "general-surgery",
            name: "General Surgery & Trauma",
            category: "Surgical Subspecialty",
            compP25: 380000,
            compP50: 465000,
            compP75: 575000,
            compP90: 710000,
            wrvuP25: 5600,
            wrvuP50: 7200,
            wrvuP75: 9100,
            wrvuP90: 11200,
            convFactorP50: 64.50,
            convFactorRange: "$58.00 – $74.00",
            callStipend24h: 1400,
            callStipendRange: "$1,000 – $1,800 / 24h",
            starkRiskThreshold: 650000
        ),
        SpecialtyBenchmark(
            id: "cardiology-interventional",
            name: "Cardiology (Interventional)",
            category: "Medical Subspecialty",
            compP25: 540000,
            compP50: 690000,
            compP75: 875000,
            compP90: 1060000,
            wrvuP25: 6700,
            wrvuP50: 8800,
            wrvuP75: 11200,
            wrvuP90: 14000,
            convFactorP50: 78.50,
            convFactorRange: "$70.00 – $90.00",
            callStipend24h: 1800,
            callStipendRange: "$1,300 – $2,400 / 24h",
            starkRiskThreshold: 960000
        ),
        SpecialtyBenchmark(
            id: "gastroenterology",
            name: "Gastroenterology",
            category: "Medical Subspecialty",
            compP25: 440000,
            compP50: 560000,
            compP75: 710000,
            compP90: 880000,
            wrvuP25: 6400,
            wrvuP50: 8300,
            wrvuP75: 10600,
            wrvuP90: 13200,
            convFactorP50: 67.50,
            convFactorRange: "$60.00 – $78.00",
            callStipend24h: 1150,
            callStipendRange: "$800 – $1,500 / 24h",
            starkRiskThreshold: 780000
        ),
        SpecialtyBenchmark(
            id: "radiology-diagnostic",
            name: "Radiology (Diagnostic & Interventional)",
            category: "Hospital-Based",
            compP25: 460000,
            compP50: 560000,
            compP75: 675000,
            compP90: 790000,
            wrvuP25: 8200,
            wrvuP50: 10200,
            wrvuP75: 12800,
            wrvuP90: 15600,
            convFactorP50: 55.00,
            convFactorRange: "$49.00 – $64.00",
            callStipend24h: 1400,
            callStipendRange: "$1,100 – $2,000 / 24h",
            starkRiskThreshold: 740000
        ),
        SpecialtyBenchmark(
            id: "anesthesiology",
            name: "Anesthesiology",
            category: "Hospital-Based",
            compP25: 405000,
            compP50: 490000,
            compP75: 595000,
            compP90: 710000,
            wrvuP25: 8500,
            wrvuP50: 10800,
            wrvuP75: 13500,
            wrvuP90: 16500,
            convFactorP50: 45.50,
            convFactorRange: "$40.00 – $53.00",
            callStipend24h: 1500,
            callStipendRange: "$1,200 – $2,200 / 24h",
            starkRiskThreshold: 680000
        ),
        SpecialtyBenchmark(
            id: "emergency-medicine",
            name: "Emergency Medicine",
            category: "Hospital-Based",
            compP25: 340000,
            compP50: 410000,
            compP75: 495000,
            compP90: 590000,
            wrvuP25: 5800,
            wrvuP50: 7100,
            wrvuP75: 8600,
            wrvuP90: 10400,
            convFactorP50: 57.50,
            convFactorRange: "$50.00 – $66.00",
            callStipend24h: 0,
            callStipendRange: "$180 – $280 / hour shift",
            starkRiskThreshold: 550000
        ),
        SpecialtyBenchmark(
            id: "internal-medicine-outpatient",
            name: "Internal Medicine (Outpatient / Hospitalist)",
            category: "Primary Care",
            compP25: 245000,
            compP50: 295000,
            compP75: 355000,
            compP90: 425000,
            wrvuP25: 4200,
            wrvuP50: 5100,
            wrvuP75: 6200,
            wrvuP90: 7400,
            convFactorP50: 57.80,
            convFactorRange: "$51.00 – $65.00",
            callStipend24h: 500,
            callStipendRange: "$350 – $750 / shift",
            starkRiskThreshold: 390000
        )
    ]
}
