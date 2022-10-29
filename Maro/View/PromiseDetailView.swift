//
//  PromiseDetailView.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/18.
//

import SwiftUI

struct PromiseDetailView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @ObservedObject var viewModel: PromiseDetailViewModel

    init(promise: PromiseEntity) {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.accentColor)]
        viewModel = PromiseDetailViewModel(promise: promise)
    }

    var body: some View {
        VStack(spacing: 0) {
            ContentInput
            CategoryInput
            MemoInput
            Spacer()
        }
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: dismissButton,
            trailing: deleteButton
        )
        .navigationTitle("상세보기")
    }
}

extension PromiseDetailView {
    var ContentInput: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("약속 내용")
                    .font(.headline)
                Spacer()
                Text("\(viewModel.inputCount)/25")
                    .foregroundColor(Color.inputCount)
            }
            TextField("약속 내용을 입력해주세요",text: $viewModel.content)
                .padding(.horizontal, 20.5)
                .padding(.vertical, 20)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 59, maxHeight: 59)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.inputBackground))
                .padding(.top, 19)
                .onSubmit {
                    viewModel.didFinishEditing()
                }
        }
        .padding(.top, 38)
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
        .padding(.top, 38)
    }
    var MemoInput: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("메모")
                    .font(.headline)
                Spacer()
            }
            TextField("메모 내용을 입력해주세요", text: $viewModel.memo)
                .padding(.horizontal, 20.5)
                .padding(.vertical, 20)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 59, maxHeight: 59)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.inputBackground))
                .padding(.top, 19)
                .onSubmit {
                    viewModel.didFinishEditing()
                }
        }
        .padding(.top, 38)
    }
    var dismissButton: some View {
        Button(action : {
            self.mode.wrappedValue.dismiss()
        }){Image(systemName: "arrow.left")}
    }
    var deleteButton: some View {
        Button(action : {
            viewModel.isShowingAlert = true
        }){Image(systemName: "trash")}
        .alert("약속 삭제", isPresented: $viewModel.isShowingAlert, actions: {
            Button("취소", role: .cancel, action: {
                viewModel.isShowingAlert = false
            })
            Button("삭제", role: .destructive, action: {
                viewModel.didAllowDeletion {
                    mode.wrappedValue.dismiss()
                }
            })
        }, message: {
          Text("해당 약속을 삭제할까요?")
        })
    }
}

