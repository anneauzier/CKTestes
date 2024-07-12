//
//  CKCrudViewModel.swift
//  cloudKit-studies
//
//  Created by Anne Auzier on 08/07/24.
//

import CloudKit
import UIKit

struct FruitModel: Hashable {
    let name: String
    let image: URL?
    let record: CKRecord
}

class CKCrudViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var fruits: [FruitModel] = []

    init() {
        fetchFruits()
    }

    func addButtonPressed() {
        guard !text.isEmpty else { return }
        addFruit(name: text)
    }
    
    private func addFruit(name: String) {
        let newFruit = CKRecord(recordType: "Fruits")
        newFruit["name"] = name
        
        guard let image = UIImage(named: "img2"),
              let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("img2.jpg"),
              let data = image.jpegData(compressionQuality: 1.0) else { return }

        do {
            try data.write(to: url)
            let asset = CKAsset(fileURL: url)
            newFruit["image"] = asset

            saveFruit(record: newFruit)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func saveFruit(record: CKRecord) {
        CKContainer.default().publicCloudDatabase.save(record) { [weak self] returnedRecord, error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self?.text = ""
                self?.fetchFruits()
            }
        }
    }

    func fetchFruits() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Fruits", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        
        var returnedFruits: [FruitModel] = []
        
        // retorna os record assim que forem encontrados
        queryOperation.recordMatchedBlock = { (_, returnedResult) in
            switch returnedResult {
            case .success(let record):
                guard let name = record["name"] as? String else { return }
                let imageAsset = record["image"] as? CKAsset
                let imageURL = imageAsset?.fileURL

                returnedFruits.append(FruitModel(name: name, image: imageURL, record: record))
            case .failure(let error):
                print("Error recordMatchedBlock: \(error)")
            }
        }

        queryOperation.queryResultBlock = { [weak self] returnedResult in
            DispatchQueue.main.async {
                self?.fruits = returnedFruits
            }
        }

        addOperation(operation: queryOperation)
    }
    
    func addOperation(operation: CKDatabaseOperation) {
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func updateFruit(fruit: FruitModel) {
        let record = fruit.record
        record["name"] = "NEW NAME!!!"
        saveFruit(record: record)
    }
    
    func deleteFruit(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let fruit = fruits[index]
        let record = fruit.record
        
        CKContainer.default().publicCloudDatabase.delete(withRecordID: record.recordID) { [weak self] returnRecordID, returnError in
            DispatchQueue.main.async {
                self?.fruits.remove(at: index)
            }
        }
    }
}

