//
//  OnBoardingTabView.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/31.
//

import SwiftUI

struct OnBoardingTabView: View {
    @Binding var isShowingOnboarding: Bool
    @State var selection: Int = 1
    @State var isShowingAlert = false

    var body: some View {
        NavigationView {
            VStack {
                TabView(selection: $selection) {
                    OnboardFirstView.tag(1)
                    OnboardSecondView.tag(2)
                    OnboardThirdView.tag(3)
                }
                .tabViewStyle(
                    PageTabViewStyle(
                        indexDisplayMode: .always
                    )
                )
                .navigationBarItems(trailing: skipButton)
            }
        }
    }
}

private extension OnBoardingTabView {
    var OnboardFirstView: some View {
        VStack(spacing: 0) {
            Text("나의 하루를 위한 하나의 약속을 확인해요")
                .onBoardTextStyle()
            Image("onBoarding1")
                .padding(.top, Constant.screenHeight / 20)
            Spacer()
        }
    }

    var OnboardSecondView: some View {
        VStack(spacing: 0) {
            Text("꼭 지켜야할 나만의 약속들을\n간편하게 관리해요")
                .onBoardTextStyle()
            Image("onBoarding2")
                .padding(.top, Constant.screenHeight / 20)
            Spacer()
        }
    }

    var OnboardThirdView: some View {
        VStack(spacing: 0) {
            ZStack {
                VStack {
                    Text("나의 하루를 위한 하나의 약속\n마로와 함께 해요")
                        .onBoardTextStyle()
                    Spacer()
                }
                VStack {
                    Spacer()
                    Image("onBoarding3")
                    Spacer()
                }
            }
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
            .padding(.horizontal)
        }
    }

    var skipButton: some View {
        Button("건너뛰기") { isShowingAlert = true }
            .opacity(selection == 3 ? 0 : 1)
            .alert("알림", isPresented: $isShowingAlert, actions: {
                Button("취소", action: { })
                Button("건너뛰기", action: { isShowingOnboarding.toggle() })
            }) {
                Text("설명을 건너뛸까요?")
            }
    }
}
