//
//  CKCrudView.swift
//  cloudKit-studies
//
//  Created by Anne Auzier on 08/07/24.
//

import SwiftUI

struct CKCrudView: View {
    
    @StateObject private var viewModel = CKCrudViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                header
                textField
                addButton
                
                List {
                    ForEach(viewModel.fruits, id: \.self) { fruit in
                        HStack {
                            Text(fruit.name)
                            if let url = fruit.image, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 150, height: 50)
                            }
                            
                        }.onTapGesture {
                            viewModel.updateFruit(fruit: fruit)
                        }
                    }.onDelete(perform: viewModel.deleteFruit)
                }.listStyle(PlainListStyle())
            }
            .padding()
            .toolbar(.hidden)
        }
    }
}

extension CKCrudView {
    private var header: some View {
        Text("List Of Elements")
            .font(.title)
            .fontWeight(.bold)
            .padding()
    }
    
    private var textField: some View {
        TextField("type something here...", text: $viewModel.text)
            .textFieldStyle(.roundedBorder)
            .padding()
    }
    
    private var addButton: some View {
        Button(action: {
            viewModel.addButtonPressed()
        }, label: {
            Text("Add Elements")
                .font(.headline)
                .padding()
                .foregroundStyle(.orange)
                .background(Color.indigo)
                .clipShape(.rect(cornerRadius: 25))
        })
    }
}

#Preview {
    CKCrudView()
}
