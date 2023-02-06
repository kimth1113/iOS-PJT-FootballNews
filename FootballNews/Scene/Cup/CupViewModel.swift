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
        Contest(name: "유로", url: URL(string: APIResouce.EuroSite)!),
        Contest(name: "코파아메리카", url: URL(string: APIResouce.CopaAmericaSite)!),
        Contest(name: "아프리카 네이션스컵", url: URL(string: APIResouce.AfricaNationsSite)!),
        Contest(name: "북중미 골드컵", url: URL(string: APIResouce.NorthAmericaSite)!),
        Contest(name: "OFC네이션스컵", url: URL(string: APIResouce.OFCNationsSite)!),
        Contest(name: "아시안컵", url: URL(string: APIResouce.AsiaSite)!),
        Contest(name: "동아시안컵", url: URL(string: APIResouce.EastAsiaSite)!),
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
