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
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.mainPurple)]
        UITextView.appearance().backgroundColor = .clear
        viewModel = PromiseDetailViewModel(promise: promise)
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Header
                ContentInput
                CategoryInput
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(
                leading: dismissButton,
                trailing: deleteButton
            )
            .navigationTitle("상세보기")
            .navigationBarTitleDisplayMode(.inline)
            if isFocused {
                onTapDismissKeyboardView
            }
            editButton
        }
        .padding(.horizontal)
    }
}

private extension PromiseDetailView {
    var Header: some View {
        HStack(spacing: 0) {
            Text(viewModel.calculateDateFormat())
                .font(.callout)
            Text(" 에 작성된 약속이에요")
                .font(.subheadline)
                .foregroundColor(.inputCount)
        }
        .padding(.top, 38)
    }

    var ContentInput: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("약속 내용")
                    .font(.headline)
                Spacer()
                Text("\(viewModel.inputCount)/25")
                    .foregroundColor(Color.inputCount)
            }
            TextField("약속 내용을 입력해주세요",text: $viewModel.content)
                .focused($isFocused)
                .customTextFieldSetting()
        }
        .padding(.top, 38)
    }
    
    var CategoryInput: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("카테고리")
                .font(.headline)
            HStack(spacing: 0) {
                Menu {
                    Picker(selection: $viewModel.selectedCategory) {
                        ForEach(viewModel.categories, id: \.self) { category in
                            Text(category)
                        }
                    } label: {

                    }
                } label: {
                    HStack {
                        Text(viewModel.selectedCategory == "선택" ? "선택" : viewModel.selectedCategory)
                        Image(systemName: "arrowtriangle.down.fill")
                    }
                    .foregroundColor(viewModel.selectedCategory == "선택" ? Color.inputForeground : .black)
                    .padding()
                    .background(Color.inputBackground)
                    .cornerRadius(10)
                }
                Spacer()
            }
            .padding(.top, 19)
        }
        .padding(.top, 38)
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

    var editButton: some View {
        VStack {
            Spacer()
            Button {
                if viewModel.isButtonAvailable() {
                    viewModel.didTapEditButton {
                        dismiss()
                    }
                }
            } label: {
                Text("수정 하기")
                    .font(.headline)
                    .foregroundColor(
                        viewModel.isButtonAvailable() ?
                        Color.white :
                        Color.inputBackground)
                    .padding(.vertical, 18)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(viewModel.isButtonAvailable() ?
                        Color.mainPurple :
                        Color.inputCount
                    )
                    .cornerRadius(10)
            }
            .padding(.bottom, 16)
        }
    }

    var onTapDismissKeyboardView: some View {
        Rectangle()
            .opacity(0.00000000000000000001)
            .onTapGesture {
                isFocused = false
            }
    }
}
