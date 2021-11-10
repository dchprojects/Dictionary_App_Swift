//
//  MDReadWordProtocol.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 29.05.2021.
//

import Foundation

protocol MDReadWordProtocol {
    
    func readWord(byWordUUID uuid: UUID,
                  _ completionHandler: @escaping(MDOperationResultWithCompletion<CDWordEntity>))
    
    func readWord(byCourseUUID courseUUID: UUID,
                  andWordText wordText: String,
                  _ completionHandler: @escaping(MDOperationResultWithCompletion<CDWordEntity>))
    
    func readWords(byCourseUUID uuid: UUID,
                   fetchLimit: Int,
                   fetchOffset: Int,
                   ascending: Bool,
                   _ completionHandler: @escaping(MDOperationsResultWithCompletion<CDWordEntity>))
    
    func readWords(fetchLimit: Int,
                   fetchOffset: Int,
                   ascending: Bool,
                   _ completionHandler: @escaping(MDOperationsResultWithCompletion<CDWordEntity>))
    
    func readAllWords(byCourseUUID uuid: UUID,
                      ascending: Bool,
                      _ completionHandler: @escaping(MDOperationsResultWithCompletion<CDWordEntity>))
    
}
