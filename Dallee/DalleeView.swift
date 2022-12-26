//
//  DalleeView.swift
//  Dallee
//
//  Created by Raúl Ferrer on 22/12/22.
//

import SwiftUI

struct DalleeView: View {
    
    @ObservedObject var viewModel: DalleeViewModel
    
    @State var description: String = "A developer sitting in front of a computer with a cap an a coffe cup."
    
    var body: some View {
        VStack {
            Text("Blow your mind with Dall-E!")
                .font(.system(.title))
            Divider()
            Spacer()
            AsyncImage(url: viewModel.imageURL) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                VStack {
                    if viewModel.isLoading {
                        ProgressView()
                    }  else {
                        Image(systemName: "photo.tv")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.indigo)
                    }
                }
                .frame(width: 300, height: 300)
                .overlay(RoundedRectangle(cornerRadius: 4)
                    .stroke(.indigo, lineWidth: 1))
            }.padding(10)
            Divider()
            TextField("What's in your mind?", text: $description, axis: .vertical)
                .lineLimit(10)
                .lineSpacing(5)
                .padding(5)
                .overlay(RoundedRectangle(cornerRadius: 4)
                    .stroke(.gray, lineWidth: 1)).padding(.vertical, 25)
            Button {
                viewModel.generateImage(query: description)
            } label: {
                Text("Create!")
                    .font(.system(.title2))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(.indigo)
                    .cornerRadius(4)
            }
            Spacer()
        }
        .padding(20)
    }
}
