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
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.accentColor)]
        UITextView.appearance().backgroundColor = .clear
        viewModel = CreatePromiseViewModel()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ContentInput
                
            CategoryInput
                
            MemoInput
        }
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: dismissButton,
            trailing: addButton
        )
        .navigationTitle("약속 만들기")
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture { isFocused = false }
    }
}

extension CreatePromiseView {
    var ContentInput: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("약속 내용")
                    .font(.headline)
                
                Spacer()
                
                Text("\(viewModel.inputCount)/25")
                    .foregroundColor(Color.inputCount)
            }
            
            TextField("약속 내용을 입력해주세요", text: $viewModel.content)
                .customTextFieldSetting()
                .focused($isFocused)
        }
        .padding(.top, 30)
    }
    
    var CategoryInput: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("카테고리")
                    .font(.headline)
                
                Spacer()
            }
            
            HStack(spacing: 0) {
                Menu {
                    Picker(selection: $viewModel.selectedCategory) {
                        ForEach(viewModel.pickers, id: \.self) { category in
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
        .padding(.top, 30)
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
    
    var dismissButton: some View {
        Button(action : {
            dismiss()
        }) {
            Image(systemName: "arrow.left")
        }
    }
    
    var addButton: some View {
        Button {
            viewModel.didTapButton {
                dismiss()
            }
        } label: {
            Text("추가")
                .foregroundColor(viewModel.isButtonAvailable() ? Color.accentColor : Color.inputCount)
        }
        .disabled(!viewModel.isButtonAvailable())
    }
}
