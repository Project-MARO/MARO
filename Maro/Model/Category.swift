//
//  Category.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/17.
//

import Foundation
import SwiftUI

@objc
public enum Category: Int16, CaseIterable {

    case study = 0
    case employment = 1
    case life = 2
    case selfImprovement = 3
    case humanRelations = 4

    public init?(string: String) {
        switch string {
        case "학업":
            self = .study
        case "취업":
            self = .employment
        case "인생":
            self = .life
        case "자기계발":
            self = .selfImprovement
        case "인간관계":
            self = .humanRelations
        default:
            self = .life
        }
    }

    public init?(int: Int16) {
        switch int {
        case 0:
            self = .study
        case 1:
            self = .employment
        case 2:
            self = .life
        case 3:
            self = .selfImprovement
        case 4:
            self = .humanRelations
        default:
            self = .life
        }
    }

    var toString: String {
        switch self {
        case .study:
            return "학업"
        case .employment:
            return "취업"
        case .life:
            return "인생"
        case .selfImprovement:
            return "자기계발"
        case .humanRelations:
            return "인간관계"
        }
    }

    var color: Color {
        switch self {
        case .study:
            return Color.studyColor
        case .employment:
            return Color.employmentColor
        case .life:
            return Color.lifeColor
        case .selfImprovement:
            return Color.selfImprovementColor
        case .humanRelations:
            return Color.humanRelationsColor
        }
    }
}
