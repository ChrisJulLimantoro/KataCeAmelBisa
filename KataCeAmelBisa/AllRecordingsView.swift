//
//  AllRecordingsView.swift
//  KataCeAmelBisa
//
//  Created by Alvin Lionel on 10/07/24.
//

import SwiftUI

struct AllRecordingsView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationView{
            VStack{
                List{
                    VStack{
                        HStack{
                            Text("Latihan Presentasi MC3")
                                .foregroundStyle(.primary)
                            Spacer()
                        }
                        HStack{
                            Text("5 Jul 2024")
                            Spacer()
                            Text("12.20")
                        }.foregroundStyle(.secondary)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            // delete
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                .listStyle(.inset)
                Spacer()
                Button{
                    //Record Button
                } label: {
                    Image(systemName: "record.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 75, height: 75)
                        .foregroundColor(.red)
                        .padding(.top)
                }
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
            }.navigationTitle("All Recordings")
                .toolbar{
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        EditButton()
                    }
                }
                .searchable(text: $searchText)
            }
    }
}



#Preview {
    AllRecordingsView()
}
