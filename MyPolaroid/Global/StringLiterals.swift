//
//  StringLiterals.swift
//  MyPolaroid
//
//  Created by 강석호 on 7/22/24.
//

import Foundation

enum StringLiterals {
    enum LabelText {
        static let onboardingTitle = "MeaningOut"
        static let nosearchTitle = "최근 검색어가 없어요"
        static let recentSearchTitle = "최근검색"
        
        enum NickNameStatus {
            static let rightCase = "사용할 수 있는 닉네임입니다"
            static let numberOfLiteralsCase = "닉네임에 숫자는 포함할 수 없어요"
            static let specialLiteralsCase = "닉네임에 @, #, $, %는 포함할 수 없어요"
            static let numberCase = "2글자 이상 10글자 미만으로 설정해주세요"
        }
    }
    
    enum ButtonTitle {
        static let launch = "시작하기"
        static let finish = "완료하기"
        static let allDelete = "전체 삭제"
        static let sortAccuracy = "정확도순"
        static let sortDate = "날짜순"
        static let sortPriceHigh = "가격높은순"
        static let sortPriceLow = "가격낮은순"
    }
    
    enum Placeholder {
        static let requestNickName = "닉네임을 입력해주세요 :)"
    }
    
    enum NavigationTitle {
        static let profileSetting = "PROFILE SETTING"
        static let Setting = "SETTING"
        static let profileEdit = "EDIT PROFILE"
    }
    
    enum AlertLabel {
        static let alertTitle = "탈퇴하기"
        static let alertMessage = "탈퇴하면 데이터가 모두 초기화됩니다. 탈퇴하시겠습니까?"
    }
}
