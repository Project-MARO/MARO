//
//  OnBoardingTabView.swift
//  Maro
//
//  Created by Kim Insub on 2022/10/31.
//

import SwiftUI

struct OnBoardingTabView: View {
    @ObservedObject private var viewModel = CreatePromiseViewModel(count: 0)
    @Binding var isShowingOnboarding: Bool
    @FocusState private var isFocused: Bool
    @State private var selection: Int = 1
    @State private var promise: String = ""
    @State private var isShowingAlert = false
    @State private var isTheFirstPageAppeared: Bool = false
    @State private var isTheSecondPageAppeared: Bool = false
    @State private var isTheThirdPageAppeared: Bool = false
    @State private var isTheFourthPageAppeared: Bool = false
    let categories = Category.allCases.map{ $0.toString }

    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack { onboardingTabView }
        } else {
            NavigationView { onboardingTabView }
        }
    }
}

private extension OnBoardingTabView {
    var onboardingTabView: some View {
        VStack {
            TabView(selection: $selection) {
                onboardingFirst.tag(1)
                onboardingSecond.tag(2)
                onboardingThird.tag(3)
                onboardingFourth.tag(4)
            }
            .navigationBarItems(trailing: skipButton)
        }
    }
    
    var onboardingFirst: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("나의 하루를 위한 하나의 약속\n마로를 시작합니다.")
                .onBoardTextStyle()
            BottomButtonView(
                type: .next,
                isButtonAvailable: true
            ) {
                selection = 2
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) { isTheFirstPageAppeared.toggle() }
            NotificationManager.shared.requestAuthorizaiton()
        }
        .opacity(isTheFirstPageAppeared ? 1 : 0)
    }

    var onboardingSecond: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("삶에서 지켜야 할 약속이 있나요?\n마로에게 알려주세요.")
                .onBoardTextStyle()
            HStack(spacing: 0) {
                Spacer()
                Text("\(viewModel.content.count)/25")
                    .foregroundColor(Color.inputCount)
            }
            TextField("긍정적인 생각하기", text: $viewModel.content)
                .customTextFieldSetting()
                .focused($isFocused)
            BottomButtonView(
                type: .next,
                isButtonAvailable: viewModel.content == "" ? false : true
            ) {
                selection = 3
            }
            .disabled(viewModel.content == "" ? true : false)
        }
        .onAppear { withAnimation(.easeInOut(duration: 1)) { isTheSecondPageAppeared.toggle() } }
        .opacity(isTheSecondPageAppeared ? 1 : 0)
    }

    var onboardingThird: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("어떤 상황에서 지켜야 할 약속인가요?")
                .onBoardTextStyle()
            HStack(spacing: 0) {
                Menu {
                    Picker(selection: $viewModel.selectedCategory) {
                        ForEach(categories, id: \.self) { category in
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
            BottomButtonView(
                type: .next,
                isButtonAvailable: viewModel.selectedCategory == "선택" ? false : true
            ) {
                selection = 4
            }
            .disabled(viewModel.selectedCategory == "선택" ? true : false)
        }
        .onAppear { withAnimation(.easeInOut(duration: 1)) { isTheThirdPageAppeared.toggle() } }
        .opacity(isTheThirdPageAppeared ? 1 : 0)
    }
    
    var onboardingFourth: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("첫 약속이 만들어졌어요!")
                .onBoardTextStyle()
            Text("더 많은 약속을 만들고 실천하세요\n매일 아침 7시 약속들 중 하나를 전달해드릴게요")
                .font(.subheadline)
                .foregroundColor(.mainTextColor)
                .multilineTextAlignment(.leading)
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Group {
                        Text("\"\(viewModel.content)\"")
                            .font(.headline)
                        Text(viewModel.selectedCategory)
                            .font(.subheadline)
                    }
                    .foregroundColor(.mainTextColor)
                    .padding(.bottom, 8)
                    Spacer()
                }
                Spacer()
            }
            BottomButtonView(type: .start, isButtonAvailable: true) {
                viewModel.didTapButton {
                    UserDefaults.standard.set("01", forKey: Constant.todayIndex)
                    UserDefaults.standard.set(viewModel.content, forKey: Constant.todayPromise)
                    NotificationManager.shared.scheduleNotification()
                    isShowingOnboarding = false
                }
            }
        }
        .onAppear { withAnimation(.easeInOut(duration: 1)) { isTheFourthPageAppeared.toggle() } }
        .opacity(isTheFourthPageAppeared ? 1 : 0)
    }

    var skipButton: some View {
        Button("건너뛰기") { isShowingAlert = true }
            .opacity(selection == 4 ? 0 : 1)
            .alert("알림", isPresented: $isShowingAlert, actions: {
                Button("취소", action: { })
                Button("건너뛰기", action: {
                    NotificationManager.shared.scheduleNotification()
                    isShowingOnboarding.toggle()
                })
            }) {
                Text("설명을 건너뛸까요?")
            }
    }
}
