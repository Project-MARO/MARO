//
//  CategoryInputView.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/31.
//

import SwiftUI

struct CategoryInputView: View {

    @Binding var selectedCategory: String
    let categories = Category.allCases.map{ $0.toString }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("카테고리")
                    .font(.headline)

                Spacer()
            }
            HStack(spacing: 0) {
                Menu {
                    Picker(selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    } label: {

                    }
                } label: {
                    HStack {
                        Text(selectedCategory == "선택" ? "선택" : selectedCategory)
                        Image(systemName: "arrowtriangle.down.fill")
                    }
                    .foregroundColor(selectedCategory == "선택" ? Color.inputForeground : .black)
                    .padding()
                    .background(Color.inputBackground)
                    .cornerRadius(10)
                }
                Spacer()
            }
            .padding(.top, 19)
        }
        .padding(.top, 30)
    }
}
