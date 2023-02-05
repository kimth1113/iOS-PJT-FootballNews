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
        Contest(name: "유로", url: URL(string: "https://www.uefa.com/uefaeuro/history/seasons/2020/matches/")!),
        Contest(name: "코파아메리카", url: URL(string: "https://www.sportingnews.com/us/soccer/news/copa-america-bracket-2021-tv-schedule-channel-stream-watch/xehy346ajvt71js2fpgzn5bxo")!),
        Contest(name: "아프리카 네이션스컵", url: URL(string: "https://www.cafonline.com/total-africa-cup-of-nations/matches/")!),
        Contest(name: "북중미 골드컵", url: URL(string: "https://www.ussoccer.com/competitions/concacaf-gold-cup-2019")!),
        Contest(name: "OFC네이션스컵", url: URL(string: "https://www.oceaniafootball.com/competition/fifa-world-cup-qatar-2022-qualifiers/")!),
        Contest(name: "아시안컵", url: URL(string: "https://www.the-afc.com/en/national/afc_asian_cup/fixtures__standings.html")!),
        Contest(name: "동아시안컵", url: URL(string: "https://eaff.com/competitions/eaff2022/result794_k.html")!),
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
