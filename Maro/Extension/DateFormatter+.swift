//
//  DateFormatter+.swift
//  마로
//
//  Created by Kim Insub on 2022/10/29.
//

import Foundation

extension DateFormatter {
    enum DateFormatType {
        case koreanYearMonthDay

        var dateFormat: String {
            switch self {
            case .koreanYearMonthDay: return "yyyy년 MM월 dd일"
            }
        }
    }

    convenience init(dateFormatType: DateFormatType) {
        self.init()
        self.dateFormat = dateFormatType.dateFormat
    }
}
