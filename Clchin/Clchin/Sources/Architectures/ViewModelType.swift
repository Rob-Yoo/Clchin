//
//  ViewModelType.swift
//  Clchin
//
//  Created by Jinyoung Yoo on 8/15/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
