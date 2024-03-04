//
//  CupViewModel.swift
//  FootballNews
//
//  Created by 김태현 on 2023/01/25.
//

import Foundation
import RxCocoa
import RxSwift

class CupViewModel {

    let disposeBag = DisposeBag()

    let contestList = BehaviorSubject(value: [
        Contest(name: "유럽축구연맹(UEFA) 공식 홈페이지", url: URL(string: APIResouce.EuroSite)!),
        Contest(name: "남미축구연맹(CONMEBOL) 공식 홈페이지", url: URL(string: APIResouce.CopaAmericaSite)!),
        Contest(name: "아프리카축구연맹(CAF) 공식 홈페이지", url: URL(string: APIResouce.AfricaNationsSite)!),
        Contest(name: "북중미&카리브해축구연맹(CONCACAF) 공식 홈페이지", url: URL(string: APIResouce.NorthAmericaSite)!),
        Contest(name: "오세아니아축구연맹(OFC) 공식 홈페이지", url: URL(string: APIResouce.OFCNationsSite)!),
        Contest(name: "아시아축구연맹(AFC) 공식 홈페이지", url: URL(string: APIResouce.AsiaSite)!),
        Contest(name: "동아시아축구연맹(EAFF) 공식 홈페이지", url: URL(string: APIResouce.EastAsiaSite)!),
    ])

    struct Input {
        let selectTap: ControlEvent<Contest>
    }

    struct Output {
        let selectTap: ControlEvent<Contest>
    }

    func transform(input: Input) -> Output {
        return Output(selectTap: input.selectTap)
    }

}
