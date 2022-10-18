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
    @State var isShowingLink = false

    init() {
        viewModel = MainViewModel()
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.accentColor)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.indicatorGray)
    }

    var body: some View {

        NavigationView {
            if isShowingOnboarding {
                OnBoardingTabView
            } else {
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
        }
    }
}

extension MainView {
    var skipButton: some View {
        Button("건너뛰기") {
            isShowingOnboarding = false
        }
    }

    var ListEmptyHeader: some View {
        ZStack {
            Image("upperBar")
            VStack {

            }
        }
    }

    var Header: some View {
        ZStack {
            Image("upperBar")
            VStack(spacing: 0) {
                if viewModel.allPromises.isEmpty {
                    Text("새로운 약속을 작성해볼까요?")
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
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 43)
                                .stroke(.white, lineWidth: 1)
                        )
                        .frame(width: 182, height: 48)
                }
            }
            .padding(.top, 80)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 300, maxHeight: 300)
    }
    var EmptyListView: some View {
        VStack {
            Spacer()
            Text("아직 작성된 약속이 없어요")
                .foregroundColor(Color.indicatorGray)
                .font(.title2)
            Spacer()
        }
    }

    var PromiseListView: some View {
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
                                .foregroundColor(.black)
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
