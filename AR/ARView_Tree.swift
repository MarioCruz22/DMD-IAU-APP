//
//  ARView.swift
//  login
//
//  Created by pedro on 12/9/22.
//

import Foundation
import SwiftUI
import RealityKit
import ARKit
import FocusEntity
import Combine

struct ARView_Tree: View {
    
    @State private var isPlacementEnabled = false
    //@State private var selectModel: String?
    @State private var selectModel: ModelAR?
    //@State private var modelConfirmedForPlacement: String?
    @State private var modelConfirmedForPlacement: ModelAR?
    
    @State public var websocketApples: [Apple] = []
    
    @StateObject private var modelWebsocket = WebsocketTasks()
    
    //private var models : [String] = {
    private var models : [ModelAR] = {
        
        let filemanager = FileManager.default
        
        guard let path = Bundle.main.resourcePath, let
                files = try?
                filemanager.contentsOfDirectory(atPath: path) else {
            return []
            
        }
        //var availableModels: [String] = []
        var availableModels: [ModelAR] = []
        for filename in files where
            filename.hasSuffix("usdz") {
                if filename == "Tree.usdz"{
                    let modelName = filename.replacingOccurrences(of: ".usdz", with: "")
                    //new
                    let model = ModelAR(modelName: modelName)
                    
                    //availableModels.append(modelName)
                    availableModels.append(model)
                }
            
        }
        return availableModels
    }()
    
    private func onAppear() {
        modelWebsocket.connect()
    }
    
    private func onDisappear() {
        modelWebsocket.disconnect()
    }
    
    
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(modelConfirmedForPlacement: self.$modelConfirmedForPlacement, websocketMessages: self.modelWebsocket.websocketMessages)
            
            if self.isPlacementEnabled {
                PlacementButtonsView(isPlacementEnabled: self.$isPlacementEnabled, selectModel: self.$selectModel, modelConfirmedForPlacement: self.$modelConfirmedForPlacement)
            } else {
                ModelPickerView(isReplacementEnabled: self.$isPlacementEnabled, selectedModel: self.$selectModel, models: self.models)
            }
        }.onAppear(perform: onAppear).onDisappear(perform: onDisappear)
    }
}

struct PlacementButtonsView: View {
    
    @Binding var isPlacementEnabled: Bool
    //@Binding var selectModel: String?
    @Binding var selectModel: ModelAR?
    //@Binding var modelConfirmedForPlacement: String?
    @Binding var modelConfirmedForPlacement: ModelAR?
    
    var body: some View {
        HStack {
            Button(action: {
                print("Debug Cancel Model Placement")
                self.resetPlacementParameters()
            }) {
                Image(systemName: "xmark")
                    .frame(width:60, height:60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
            
            Button(action: {
                print("Debug Confirm Model Placement")
                
                self.modelConfirmedForPlacement = self.selectModel
                
                self.resetPlacementParameters()
            }) {
                Image(systemName: "checkmark")
                    .frame(width:60, height:60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
        }
    }
    
    func resetPlacementParameters() {
        self.isPlacementEnabled = false
        self.selectModel = nil
    }
}

struct ModelPickerView: View {
    
    @Binding var isReplacementEnabled: Bool
    //@Binding var selectedModel: String?
    @Binding var selectedModel: ModelAR?
    //var models: [String]
    var models: [ModelAR]
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                ForEach(0 ..< self.models.count) {
                    index in
                    Button(action: {
                        print("DEBUG selected name: \(self.models[index].modelName)")
                        self.selectedModel = self.models[index]
                        self.isReplacementEnabled = true
                    }) {
                        Image(uiImage: self.models[index].image)
                        .resizable()
                        .frame(height: 80)
                        .aspectRatio(1/1, contentMode: .fit)
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle()    )
                }
            }
        }
        .padding(20)
        .background(Color.black.opacity(0.5))    }
}

struct ARViewContainer: UIViewRepresentable {
    
    //@Binding var modelConfirmedForPlacement: String?
    @Binding var modelConfirmedForPlacement: ModelAR?
    var websocketMessages: [Apple]
    
    
    

    
    func makeUIView(context: Context) -> ARView {
        let arView = CustomARView(frame: .zero)
        
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
        var treePositionX: Float = 0.0
        var treePositionY: Float = 0.0
        var treePositionZ: Float = 0.0
        
        //if let modelName = self.modelConfirmedForPlacement {
        if let model = self.modelConfirmedForPlacement {
            //print("Adding model to scene \(modelName)")
            
            //let filename = modelName + ".usdz"
            //let modelEntity = try! ModelEntity.loadModel(named: filename)
            //let anchorEntity = AnchorEntity(plane: .any)
            //anchorEntity.addChild(modelEntity)
            
            //uiView.scene.addAnchor(anchorEntity)
            
            if let modelEntity = model.modelEntity {
                print("DEBUG: Adding model to scene \(model.modelName)")
                
                let anchorEntity = AnchorEntity(plane: .any)
                
                //Se quisermos adicionar vario colocamos o clone
                // se nao colocarmos o clone substitui o modelo existente
                anchorEntity.addChild(modelEntity.clone(recursive: true))
                
                let anchorWorldTransform = anchorEntity.convert(transform: .identity, to: nil)
                uiView.scene.addAnchor(anchorEntity)
                treePositionX = anchorEntity.position.x
                treePositionY = anchorEntity.position.y
                treePositionY = anchorEntity.position.z
                //print("anchorEntity \(anchorEntity.position)")
                print("DEBUG treePositionx \(treePositionX) treePositionY \(treePositionY) treePositionZ \(treePositionZ)")
            } else {
                print("DEBUG: Unable to load out modelEntity for \(model.modelName)")
            }
            
            
            DispatchQueue.main.async {
                self.modelConfirmedForPlacement = nil
            }
            
        }
        
        if self.websocketMessages.isEmpty {
            print("DEBUG dentro do Update: Lista Vazia")
        } else {
            
            let anchorExists = uiView.scene.anchors[uiView.scene.anchors.endIndex-1].position
            let anchorExists_1 = uiView.scene.anchors[uiView.scene.anchors.endIndex-1]
            print("anchor exists: \(anchorExists)")
            
            let filename = "Apple2.usdz"
            let modelEntity_2 = try! ModelEntity.loadModel(named: filename)
            
            //print("DEBUG dentro do Update: \(self.websocketMessages)")
            print("DEBUG dentro update treePositionx \(treePositionX) treePositionY \(treePositionY) treePositionZ \(treePositionZ)")
            
            for apple in self.websocketMessages{
//                print(anchorExists.x)
//                print(anchorExists.y)
//                print(anchorExists.z)
                print("Tree anchor: ", anchorExists)
                var anchorEntity_2 = AnchorEntity()
//                anchorEntity_2.position.x = anchorExists.x //+ Float(apple.lat) / 10
//                anchorEntity_2.position.y = anchorExists.y //+ Float(apple.lon) / 10
//                anchorEntity_2.position.z = anchorExists.z //+ Float(apple.alt) / 10
                anchorEntity_2.position.x = Float(apple.lat) / -3
                anchorEntity_2.position.y = Float(apple.lon)
                anchorEntity_2.position.z = Float(apple.alt) * -14
                //anchorEntity_2.addChild(modelEntity_2.clone(recursive: true))
                anchorExists_1.addChild(modelEntity_2.clone(recursive: true))
                modelEntity_2.setPosition(SIMD3<Float> (Float(apple.lat)-0.5, Float(apple.lon)+1.3, Float(apple.alt)+1.9), relativeTo: anchorExists_1)
                //uiView.scene.addAnchor(anchorEntity_2)
                print("anchor entity: \(anchorEntity_2.position)")
            }
            
            
        }
    }
}

class CustomARView: ARView {
    let focusSquare = FESquare()
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        
        focusSquare.viewDelegate = self
        focusSquare.delegate = self
        focusSquare.setAutoUpdate(to: true)
        
        self.setupARView()
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupARView() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
        }
        
        self.session.run(config)
    }
}

extension CustomARView: FEDelegate {
    func toTrackingState() {
    }
    
    func toInitializingState() {
    }
}

struct Apple: Decodable {
    var lat: Double
    var lon: Double
    var alt: Double
    var width: Double
    var weeks: Int
}

struct Map: Decodable {
    var apple: [Apple]
}


struct Mario: Decodable {
    var map: Map
}

struct ReceivingMessage: Decodable {
    var mario: Mario
}


final class WebsocketTasks: ObservableObject {
    @Published private(set) var websocketMessages: [Apple] = []
    @State public var websocketApplesModel: [Apple] = []
    
    private var webSocketTask: URLSessionWebSocketTask? // 1
    // MARK: - Connection
    func connect() { // 2
        let url = URL(string: "ws://172.22.21.135:3306")! // 3
        print("CONNECT")
        webSocketTask = URLSession.shared.webSocketTask(with: url) // 4
        webSocketTask?.receive(completionHandler: onReceive) // 5
        webSocketTask?.resume() // 6
    }
    	
    func disconnect() { // 7
        webSocketTask?.cancel(with: .normalClosure, reason: nil) // 8
    }

    private func onReceive(incoming: Result<URLSessionWebSocketTask.Message, Error>) {
        webSocketTask?.receive(completionHandler: onReceive)

                if case .success(let message) = incoming {
                    switch message {
                    case .string(let text):
                        onMessage(message: text)
                    case .data(let data):
                        print("data: \(data)")
                    @unknown default:
                        print("erro")
                    }
                    
                }
                else if case .failure(let error) = incoming {
                    print("Error", error)
                }
    }
    
    private func onMessage(message: String) {
        
        
        
        
        
        
        //print(message.string)
        var message_new = message.replacingOccurrences(of: "'", with: "\"")
        
        let data = Data(message_new.utf8)
        print("data: \(data)")

//        do {
//            // make sure this JSON is in the format we expect
//            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                print("json: \(json)")
//                // try to read out a string array
//                if let mario = json["mario"] as? [String] {
//                    print(mario)
//                }
//            }
//        } catch let error as NSError {
//            print("Failed to load: \(error.localizedDescription)")
//        }
        	

        let chatMessage = try? JSONDecoder().decode(ReceivingMessage.self, from: Data(message_new.utf8))

        //print("DEBUG websocket_2:", chatMessage?.mario.map.apple )
        //var test = chatMessage?.mario.map.apple
        //print("test: \(test)")
        
        for x in chatMessage!.mario.map.apple {
            print(x.lat)
        }

            DispatchQueue.main.async {
                withAnimation(.spring()) {
                    self.websocketMessages.append(contentsOf: (chatMessage?.mario.map.apple)!)
                    self.websocketApplesModel = self.websocketMessages
                }
            }
        }
    }


struct ARView_Tree_Previews: PreviewProvider {
    static var previews: some View {
        ARView_Tree()
    }
}
