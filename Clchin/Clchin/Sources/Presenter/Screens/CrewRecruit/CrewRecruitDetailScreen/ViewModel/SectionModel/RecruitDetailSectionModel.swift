//
//  RecruitDetailSectionModel.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/31/24.
//

import RxDataSources

struct HeaderSectionModel {
    let imageURL: String
    let recruitTitle: String
    let climbingType: String
}

struct BodySectionModel {
    let hostProfileImageURL: String?
    let hostName: String
    let recruitText: String
}

struct FooterSectionModel {
    let empty: String
}

enum RecruitDetailSectionType {
    case header(HeaderSectionModel)
    case body(BodySectionModel)
    case footer(FooterSectionModel)
}

struct RecruitDetailSectionModel {
    var items: [RecruitDetailSectionType]
}

extension RecruitDetailSectionModel: SectionModelType {
    init(original: RecruitDetailSectionModel, items: [RecruitDetailSectionType]) {
        self = original
        self.items = items
    }
}
