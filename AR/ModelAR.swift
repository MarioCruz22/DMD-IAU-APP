//
//  Model.swift
//  login
//
//  Created by pedro on 12/12/22.
//

import UIKit
import RealityKit
import Combine

class ModelAR {
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?
    
    private var cancellable: AnyCancellable? = nil
    
    init(modelName: String) {
        self.modelName = modelName
        self.image = UIImage(named: modelName)!
        
        let fileName = modelName + ".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: fileName)
            .sink(receiveCompletion: { loadCompletion in
                //Handle Error
                print("DEBUG: Unable to load modelEntity for modelName: \(self.modelName)")
            }, receiveValue: { modelEntity in
                //Get out modelEntity
                self.modelEntity = modelEntity
                print("DEBUG: successfully loaded modelEntity for modelName: \(self.modelName)")
            })
    }
}
