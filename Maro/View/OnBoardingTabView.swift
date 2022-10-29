//
//  OnBoardingTabView.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/17.
//

import SwiftUI

extension MainView {
    var OnBoardingTabView: some View {
        TabView {
            OnboardFirstView
            OnboardSecondView
            OnboardThirdView
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .toolbar {
            Button("건너뛰기") {
                isShowingOnboarding = false
            }
        }
    }

    private var OnboardFirstView: some View {
        VStack(spacing: 0) {
            Text("나의 하루를 위한 하나의 약속을 확인해요")
                .font(.body)
                .padding(.top, 101)
                .frame(height: 20)
            Image("onBoarding1")
                .padding(.top, 130)

            Spacer()
        }
        .padding(.horizontal)
    }

    private var OnboardSecondView: some View {
        VStack(spacing: 0) {
            Text("꼭 지켜야할 나만의 약속들을\n간편하게 관리해요")
                .font(.body)
                .padding(.top, 50)
                .multilineTextAlignment(.center)
            Image("onBoarding2")
                .padding(.top, 62)
            Spacer()
        }
        .padding(.horizontal)
    }

    private var OnboardThirdView: some View {
        ZStack {
            Image("onBoarding3")
            VStack {
                Spacer()
                Button {
                    isShowingOnboarding = false
                } label: {
                    Text("시작하기")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 56, maxHeight: 56)
                        .foregroundColor(.white)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }
                .padding(.bottom, 51)
            }
        }
        .padding(.horizontal)
    }
}
