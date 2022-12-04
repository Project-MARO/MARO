//
//  CreatePromiseView.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/17.
//

import SwiftUI

struct CreatePromiseView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: CreatePromiseViewModel
    @FocusState private var isFocused: Bool
    
    init(count: Int) {
        self.viewModel = CreatePromiseViewModel(count: count)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.mainPurple)]
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            onTapDismissKeyboard
            VStack(spacing: 0) {
                contentInput
                categoryInput
                Spacer()
                editButton
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: dismissButton)
        .navigationTitle("약속 만들기")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal)
    }
}

private extension CreatePromiseView {
    var contentInput: some View {
        ContentInputView(
            isFocused: $isFocused,
            content: $viewModel.content,
            inputCount: viewModel.inputCount
        )
    }

    var categoryInput: some View {
        CategoryInputView(
            selectedCategory: $viewModel.selectedCategory
        )
    }
    
    var MemoInput: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("메모")
                    .font(.headline)

                Spacer()
            }

            TextEditor(text: $viewModel.memo)
                .focused($isFocused)
                .padding(.horizontal, 20.5)
                .padding(.vertical, 20)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 59, maxHeight: .infinity)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.inputBackground))
                .padding(.top, 19)
        }
        .padding(.top, 30)
        .padding(.bottom)
    }

    @ViewBuilder
    var onTapDismissKeyboard: some View {
        if isFocused {
            OnTapDismissKeyboardView(isFocused: $isFocused)
        }
    }

    var editButton: some View {
        BottomButtonView(
            type: .create,
            isButtonAvailable: viewModel.isButtonAvailable()
        ) {
            viewModel.didTapButton {
                dismiss()
            }
        }
        .disabled(!viewModel.isButtonAvailable())
    }
    
    var dismissButton: some View {
        DismissButton { dismiss() }
    }
}
