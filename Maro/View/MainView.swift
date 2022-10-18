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
    @State var isShowingLink: Bool = false
    @State var isSkippingOnboarding: Bool = false
    @State var selection: Int = 1
    
    init() {
        viewModel = MainViewModel()
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.accentColor)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.indicatorGray)
        NotificationManager.shared.requestAuthorization()
        NotificationManager.shared.scheduleNotification(viewModel.randomePromise?.description ?? "약속을 등록해보세요!")
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                Header
                
                Spacer()
                
                if viewModel.allPromises.isEmpty {
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
    var skipButton: some View {
        Button("건너뛰기") { isSkippingOnboarding.toggle() }
            .opacity(selection == 3 ? 0 : 1)
            .alert("알림", isPresented: $isSkippingOnboarding, actions: {
                Button("취소", action: { })
                Button("건너뛰기", action: { isShowingOnboarding.toggle() })
            }) {
                Text("설명을 건너뛸까요?")
            }
    }

    private var Header: some View {
        Rectangle()
            .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
            .ignoresSafeArea()
            .frame(height: Constant.screenHeight * 0.35)
            .foregroundColor(Color.accentColor)
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
                
                if viewModel.allPromises.isEmpty {
                    Text("새로운 약속을 만들어볼까요?")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.bottom, 28)
                } else {
                    Text("오늘은 \(viewModel.findIndex(promise: viewModel.randomePromise))번 약속을 지켜볼까요?")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.bottom, 11)
                    Text("\(viewModel.randomePromise?.content ?? "")")
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding(.bottom, 28)
                        .frame(minWidth: 0, maxWidth: 264)
                }
                
                NavigationLink {
                    CreatePromiseView()
                } label: {
                    Text("+ 새 약속 만들기")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 28)
                        .overlay {
                            Capsule().stroke(.white, lineWidth: 1)
                    }
                }
                
                Spacer()
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
                ForEach(viewModel.allPromises) { promise in
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
                            Text("\(promise.content ?? "")")
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
