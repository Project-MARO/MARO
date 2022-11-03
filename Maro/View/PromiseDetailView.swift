//
//  PromiseDetailView.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/18.
//

import SwiftUI

struct PromiseDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: PromiseDetailViewModel
    @FocusState private var isFocused: Bool

    init(promise: PromiseEntity) {
        viewModel = PromiseDetailViewModel(promise: promise)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.mainPurple)]
        UITextView.appearance().backgroundColor = .clear
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                header
                contentInput
                categoryInput
                Spacer()
            }
            onTapDismissKeyboard
            editButton
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: dismissButton,
            trailing: deleteButton
        )
        .navigationTitle("상세보기")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal)
    }
}

private extension PromiseDetailView {
    var header: some View {
        HStack(spacing: 0) {
            Text(viewModel.calculateDateFormat())
                .font(.callout)
            Text(" 에 작성된 약속이에요")
                .font(.subheadline)
                .foregroundColor(.inputCount)
        }
        .padding(.top, 38)
    }

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
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("메모")
                    .font(.headline)
                Spacer()
                Text("\(viewModel.memoCount)/100")
                    .foregroundColor(Color.inputCount)
            }

            if #available(iOS 16.0, *){
                Text(viewModel.memo.isEmpty ? "Your placeholder" : viewModel.memo)
                    .font(.body)
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20.5)
                    .opacity(viewModel.memo.isEmpty ? 1 : 0.5)
                    .frame(maxWidth: .infinity, minHeight: 40, alignment: .leading)
                    .background(Color.inputBackground)
                    .cornerRadius(10)
                    .overlay(
                        TextEditor(text: $viewModel.memo)
                            .font(.body)
                            .foregroundColor(Color.black)
                            .scrollContentBackground(.hidden)
                            .background(Color.inputBackground)
                            .cornerRadius(10)
                            .padding(.horizontal, 20.5)
                    )
                    .padding(.top, 19)
            }
        }
        .padding(.top, 38)
    }

    var editButton: some View {
        BottomButtonView(
            type: .edit,
            isButtonAvailable: viewModel.isButtonAvailable()) {
                viewModel.didTapEditButton {
                    dismiss()
                }
            }
            .disabled(!viewModel.isButtonAvailable())
    }

    @ViewBuilder
    var onTapDismissKeyboard: some View {
        if isFocused {
            OnTapDismissKeyboardView(isFocused: $isFocused)
        }
    }
    
    var dismissButton: some View {
        Button(action : {
            dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(.mainPurple)
        }
    }
    
    var deleteButton: some View {
        Button(action : {
            viewModel.isShowingAlert = true
        }) {
            Text("삭제")
                .foregroundColor(.mainPurple)
        }
        .alert("약속 삭제", isPresented: $viewModel.isShowingAlert, actions: {
            Button("취소", role: .cancel, action: {
                viewModel.isShowingAlert = false
            })
            Button("삭제", role: .destructive, action: {
                viewModel.didAllowDeletion {
                    dismiss()
                }
            })
        }, message: {
          Text("해당 약속을 삭제할까요?")
        })
    }
}
