//
//  MDReadWordCoreDataStorageOperation.swift
//  MyDictionary_App_Swift
//
//  Created by Dmytro Chumakov on 08.07.2021.
//

import Foundation
import CoreData

final class MDReadWordCoreDataStorageOperation: MDOperation {
    
    fileprivate let managedObjectContext: NSManagedObjectContext
    fileprivate let wordStorage: MDWordCoreDataStorage
    fileprivate let wordId: Int64
    fileprivate let result: MDOperationResultWithCompletion<WordResponse>?
    
    init(managedObjectContext: NSManagedObjectContext,
         wordStorage: MDWordCoreDataStorage,
         wordId: Int64,
         result: MDOperationResultWithCompletion<WordResponse>?) {
        
        self.managedObjectContext = managedObjectContext
        self.wordStorage = wordStorage
        self.wordId = wordId
        self.result = result
        
        super.init()
    }
    
    override func main() {
        
        let fetchRequest = NSFetchRequest<CDWordResponseEntity>(entityName: CoreDataEntityName.CDWordResponseEntity)
        fetchRequest.predicate = NSPredicate(format: "\(CDWordResponseEntityAttributeName.wordId) == %i", wordId)
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { [weak self] asynchronousFetchResult in
            
            if let result = asynchronousFetchResult.finalResult {
                if let word = result.map({ $0.wordResponse }).first {
                    DispatchQueue.main.async {
                        self?.result?(.success(word))
                        self?.finish()
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.result?(.failure(MDEntityOperationError.cantFindEntity))
                        self?.finish()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self?.result?(.failure(MDEntityOperationError.cantFindEntity))
                    self?.finish()
                }
            }
            
        }
        
        do {
            try managedObjectContext.execute(asynchronousFetchRequest)
        } catch let error {
            self.result?(.failure(error))
            self.finish()
        }
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
        self.finish()
    }
    
}

final class MDReadWordsCoreDataStorageOperation: MDOperation {
    
    fileprivate let managedObjectContext: NSManagedObjectContext
    fileprivate let wordStorage: MDWordCoreDataStorage
    fileprivate let fetchLimit: Int
    fileprivate let fetchOffset: Int
    fileprivate let result: MDOperationsResultWithCompletion<WordResponse>?
    
    init(managedObjectContext: NSManagedObjectContext,
         wordStorage: MDWordCoreDataStorage,
         fetchLimit: Int,
         fetchOffset: Int,
         result: MDOperationsResultWithCompletion<WordResponse>?) {
        
        self.managedObjectContext = managedObjectContext
        self.wordStorage = wordStorage
        self.fetchLimit = fetchLimit
        self.fetchOffset = fetchOffset
        self.result = result
        
        super.init()
    }
    
    override func main() {
        
        let fetchRequest = NSFetchRequest<CDWordResponseEntity>(entityName: CoreDataEntityName.CDWordResponseEntity)
        
        fetchRequest.fetchLimit = self.fetchLimit
        fetchRequest.fetchOffset = self.fetchOffset
        
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { [weak self] asynchronousFetchResult in
            
            if let result = asynchronousFetchResult.finalResult {
                DispatchQueue.main.async {
                    self?.result?(.success(result.map({ $0.wordResponse })))
                    self?.finish()
                }
            } else {
                DispatchQueue.main.async {
                    self?.result?(.failure(MDEntityOperationError.cantFindEntity))
                    self?.finish()
                }
            }
            
        }
        
        do {
            try managedObjectContext.execute(asynchronousFetchRequest)
        } catch let error {
            DispatchQueue.main.async {
                self.result?(.failure(error))
                self.finish()
            }
        }
        
    }
    
    deinit {
        debugPrint(#function, Self.self)
        self.finish()
    }
    
}
