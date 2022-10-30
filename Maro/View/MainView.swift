//
//  ContentView.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/17.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel: MainViewModel
    @AppStorage("isShowingOnboarding") var isShowingOnboarding: Bool = true
    @State var isSkippingOnboarding: Bool = false
    @State var selection: Int = 1
    
    init() {
        viewModel = MainViewModel()
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.accentColor)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.indicatorGray)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Header
                Spacer()
                if viewModel.promises.isEmpty {
                    EmptyListView
                } else {
                    PromiseListView
                }
            }
            .ignoresSafeArea()
            .onAppear {
                viewModel.onAppear()
            }
        }
        .fullScreenCover(isPresented: $isShowingOnboarding) {
            OnBoardingTabView
                .padding(.horizontal)
        }
    }
}

extension MainView {
    private var Header: some View {
        Rectangle()
            .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
            .ignoresSafeArea()
            .frame(height: Constant.screenHeight * 0.35)
            .foregroundColor(Color.mainPurple)
            .padding(.bottom)
            .overlay { overlayView }
    }
    
    private var overlayView: some View {
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
                NavigationLink("", isActive: $viewModel.isShowingLink) {
                    CreatePromiseView()
                }
            }
        }
    }
    
    private var EmptyListView: some View {
        VStack {
            Spacer()
            
            Text("아직 작성된 약속이 없어요")
                .foregroundColor(Color.indicatorGray)
                .font(.title2)
            
            Spacer()
        }
    }
    
    private var PromiseListView: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.promises) { promise in
                    NavigationLink {
                        PromiseDetailView(promise: promise)
                    } label: {
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
                .padding(.top, 16)
                
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}
