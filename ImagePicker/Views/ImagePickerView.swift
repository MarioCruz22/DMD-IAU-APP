import SwiftUI
import Vision

struct ImagePickerView: View {
    @EnvironmentObject var vm: ImagePickerViewModel
    @EnvironmentObject var lvm: LoginViewModel
    @EnvironmentObject var authentication: Authentication
    @FocusState var nameField: Bool
    
    @State private var classificationLables: String = ""
    @State private var showingAlert = false
    let model = MobileNetV2()
    
    private func performImageClassification () {
        guard let image = vm.image,
        let resizedImage = image.resizeImageTo(size: CGSize(width: 224, height: 224)),
              let buffer = resizedImage.convertToBuffer() else {
            return
        }
        
        let output = try? model.prediction(image: buffer)
        
        if let output = output {
            
            print("\(output.classLabel)")
            
            let results = output.classLabelProbs.sorted {
                $0.1 > $1.1
            }[0...2]
            var newKey: String = ""
            let result = results.map { (key, value) in
                let newValue = value*100
                let doubleStr = String(format: "%.2f", newValue)
                
                
                newKey = String(key.split(separator: ",")[0])
                
                return "\(newKey)= \(doubleStr)%"
            }.joined(separator: "\n")
            
            self.classificationLables = result
            print("DEBUG: LABELS: \(result)")
        }
        
        
    }
    
    
    
    
    var body: some View {
        NavigationView {
            VStack {
                HStack (){
                    Spacer()
                    Button{
                        lvm.signout { success in
                            authentication.updateValidation(success: success)
                        }
                        authentication.updateValidation(success: false)
                    } label: {
                        ButtonLabel(symbolName: "rectangle.portrait.and.arrow.right", label: "Logout")
                    }
                }.padding()
                
                
                if !vm.isEditing{
                    imageScroll
                }
                
                selectedImage
                
                VStack {
                    if vm.image != nil{
                        editorGroup
                        Button{
                            self.performImageClassification()
                            showingAlert = true
                        } label: {
                            ButtonLabel(symbolName: "eye.fill", label: "Classify")
                        }.alert(self.classificationLables, isPresented: $showingAlert) {
                            Button("OK", role: .cancel) { }
                        }
                    }
                    if !vm.isEditing {
                        pickerButtons
                    }
                }
                .padding()
                Spacer()
                
                }
            .task {
                if FileManager().docExist(named: fileName) {
                    vm.loadMyImagesJSONFile()
                }
            }
                .sheet(isPresented: $vm.showPicker) {
                ImagePicker(sourceType: vm.source == .library ? .photoLibrary : .camera, selectedImage: $vm.image)
                    .ignoresSafeArea()
            }
                .alert("Error", isPresented: $vm.showFileAlert, presenting: vm.appError, actions: {cameraError in cameraError.button}, message: {cameraError in Text(cameraError.message)})
            .navigationTitle("My Images")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button {
                            nameField = false
                        } label : {
                            Image(systemName: "keyboard.chevron.compact.down")
                        }
                    }
                }
            }
            
            
        }
        //.navigationViewStyle(DoubleColumnNavigationViewStyle())
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension ImagePickerView {
    var imageScroll: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 10) {
                ForEach(vm.myImages) { myImage in
                    VStack{
                        Image(uiImage: myImage.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width:125, height: 125)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .shadow(color: .black.opacity(0.6), radius: 2, x:2, y:2)
                        Text(myImage.name)
                    }
                    .onTapGesture{
                        vm.display(myImage)
                    }
                }
            }
        }.padding(.horizontal)
    }
    
    var selectedImage: some View {
        Group {
            if let image = vm.image {
                ZoomableScrollView {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 0, maxWidth: .infinity)
                }
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.6)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.horizontal)
            }
        }
    }
    
    var editorGroup: some View {
        Group {
            TextField("Image Name", text: $vm.imageName) { isEditing in
                vm.isEditing = isEditing
            }
            .focused($nameField, equals: true)
            .textFieldStyle(.roundedBorder)
            
            HStack {
                Button {
                    if vm.selectedImage == nil {
                        vm.addMyImage(vm.imageName, image: vm.image!)
                    } else {
                        vm.updateSelected()
                        nameField = false
                    }
                } label: {
                    ButtonLabel (symbolName: vm.selectedImage == nil ? "square.and.arrow.down.fill": "square.and.arrow.up.fill", label: vm.selectedImage == nil ? "Save" : "Update")
                }
                .disabled(vm.buttonDisabled)
                .opacity(vm.buttonDisabled ? 0.6 : 1)
                if !vm.deleteButtonIsHidden {
                    Button {
                        vm.deleteselected()
                    } label: {
                        ButtonLabel(symbolName: "trash", label: "delete")
                    }
                }
                
            }
        }
    }
    
    var pickerButtons: some View {
        HStack {
            Button{
                vm.source = .camera
                vm.showPhotoPicker()
            } label: {
                ButtonLabel(symbolName: "camera", label: "Camera")
            }
            .alert("Error", isPresented: $vm.showCameraAlert, presenting: vm.cameraError, actions: {cameraError in cameraError.button}, message: {cameraError in Text(cameraError.message)})
            
            Button{
                vm.source = .library
                vm.showPhotoPicker()
            } label: {
                ButtonLabel(symbolName: "photo", label: "Photos")
            }
        }
    }
}

