//
//  OnBoardingTabView.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/17.
//

import SwiftUI

extension MainView {    
    var OnBoardingTabView: some View {
        VStack {
            HStack {
                Spacer()
                
                skipButton
            }
            .padding(.bottom, 50)
            
            TabView(selection: $selection) {
                OnboardFirstView.tag(1)
                OnboardSecondView.tag(2)
                OnboardThirdView.tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        }
    }
    
    private var OnboardFirstView: some View {
        VStack(spacing: 0) {
            Text("나의 하루를 위한 하나의 약속을 확인해요")
                .bodyFontSetting()
            
            Image("onBoarding1")
                .padding(.top, Constant.screenHeight / 20)
            
            Spacer()
        }
    }
    
    private var OnboardSecondView: some View {
        VStack(spacing: 0) {
            Text("꼭 지켜야할 나만의 약속들을\n간편하게 관리해요")
                .bodyFontSetting()
            
            Image("onBoarding2")
                .padding(.top, Constant.screenHeight / 20)
            
            Spacer()
        }
    }
    
    private var OnboardThirdView: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Image("onBoarding3")
                .padding(.bottom, 40)
            
            Text("나의 하루를 위한 하나의 약속\n마로와 함께 해요")
                .bodyFontSetting()

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
}


