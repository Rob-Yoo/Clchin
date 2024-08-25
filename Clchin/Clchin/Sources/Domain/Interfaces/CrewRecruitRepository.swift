//
//  CrewRecruitRepository.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/25/24.
//

import Foundation

protocol CrewRecruitRepository {
    func fetchCrewRecruitList(
        isPagination: Bool,
        completionHandler: @escaping (Result<[CrewRecruit], NetworkError>) -> Void
    )
    
    func uploadCrewRecruit(post: UploadCrewRecruitBodyDTO)
}
