//
//  ContentView.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/17.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel = MainViewModel()
    @AppStorage("isShowingOnboarding") var isShowingOnboarding: Bool = true
    
    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.accentColor)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.indicatorGray)
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack { bodyView }
        } else {
            NavigationView { bodyView }
        }
    }
}

private extension MainView {
    var bodyView: some View {
        VStack(spacing: 0) {
            header
            Spacer()
            promiseList
        }
        .onAppear {
            viewModel.onAppear()
        }
        .fullScreenCover(isPresented: $isShowingOnboarding) {
            OnBoardingTabView(isShowingOnboarding: $isShowingOnboarding)
            .padding(.horizontal)
        }
    }

    var header: some View {
        Rectangle()
            .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
            .ignoresSafeArea()
            .frame(height: Constant.screenHeight * 0.3)
            .foregroundColor(Color.mainPurple)
            .padding(.bottom)
            .overlay { overlayView }
    }
    
    var overlayView: some View {
        ZStack {
            VStack {
                HStack {
                    Image("cloudTwo")
                        .padding(.trailing, 400)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Image("cloudOne")
                }
                .padding(.bottom, 40)
            }
            
            VStack (alignment: .center, spacing: 0) {
                Spacer()

                if viewModel.promises.isEmpty {
                    Text("새로운 약속을 만들어볼까요?")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.bottom, 28)
                } else {
                    Text("오늘은 \(viewModel.findIndex(promise: viewModel.todayPromise))번 약속을 지켜볼까요?")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.bottom, 11)
                    Text("\(viewModel.todayPromise?.content ?? "")")
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.bottom, 28)
                        .frame(minWidth: 0, maxWidth: 264)
                }

                Button {
                    if viewModel.isCreatePromiseAvailable() {
                        viewModel.isShowingLink = true
                    } else {
                        viewModel.isShowongAlert = true
                    }
                } label: {
                    Text("+ 새 약속 만들기")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 28)
                        .overlay {
                            Capsule().stroke(.white, lineWidth: 1)
                        }
                }
                .padding(.bottom, 56)
                .alert(isPresented: $viewModel.isShowongAlert) {
                    Alert(
                        title: Text("알림"),
                        message: Text("최대 10개의 약속을 만들 수 있어요."),
                        dismissButton: .default(Text("확인"))
                    )
                }
                
                if #available(iOS 16.0, *) {
                    NavigationLink("", isActive: $viewModel.isShowingLink) {
                        CreatePromiseView()
                    }
                    .toolbar(.hidden)
                } else {
                    NavigationLink("", isActive: $viewModel.isShowingLink) {
                        CreatePromiseView()
                    }
                    .navigationBarHidden(true)
                }

            }
        }
    }

    @ViewBuilder
    var promiseList: some View {
        switch viewModel.listStatus {
        case .emptyList:
            emptyListView
        case .filledList:
            promiseListView
        }
    }
    
    var emptyListView: some View {
        VStack {
            Spacer()
            
            Text("아직 작성된 약속이 없어요")
                .foregroundColor(Color.indicatorGray)
                .font(.title2)
            
            Spacer()
        }
    }
    
    var promiseListView: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.promises) { promise in
                    NavigationLink {
                        PromiseDetailView(promise: promise)
                    } label: {
                        PromiseCellView(promise: promise)
                    }
                }
                .padding(.top, 16)

                Spacer()
            }
        }
        .padding(.horizontal)
    }

    func PromiseCellView(promise: PromiseEntity) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(viewModel.findIndex(promise: promise))
                    .foregroundColor(Color.accentColor)
                    .font(.headline)
                Text(promise.categoryEnum.toString)
                    .foregroundColor(.white)
                    .font(.callout)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(promise.categoryEnum.color)
                    .cornerRadius(5)
                Spacer()
            }
            Text("\(promise.content)")
                .foregroundColor(.mainTextColor)
                .padding(.top, 6)
        }
        .padding(20)
        .background(Color.inputBackground)
        .cornerRadius(10)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 97, maxHeight: 97)
    }
}
