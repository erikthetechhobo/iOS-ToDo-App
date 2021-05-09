//
//  ContentView.swift
//  ToDo
//
//  Created by Erik Schroeder on 5/8/21.
//

import SwiftUI

struct ContentView: View {
    
    //properites
    //
    //gives ability to store/delete data conected to the app
    @Environment(\.managedObjectContext) var context
    //fetches all the stored list items and stores it as items
    @FetchRequest(fetchRequest: ListItem.getAllListItems()) var items: FetchedResults<ListItem>
    //empties text field
    @State var text: String = ""
    
    var body: some View {
        List {
            //Title, text field, and button container
            Section {
                LazyVStack(alignment: .leading, spacing: 0) {
                    //title
                    Text("My to do's")
                        .foregroundColor(.green)
                        .font(.system(size: 32))
                        .underline()
                        .padding(5)
                    HStack {
                        //$text is the assigned variable for textfield
                        TextField("List Item", text: $text)
                            //text field styling
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 40)
                                    .stroke(Color .green, lineWidth: 1)
                            )
                        Button(action: {
                            //if the text field isn't empty
                            if !text.isEmpty {
                                //creates and empty list item
                                let newItem = ListItem(context: context)
                                //assigns the name and date
                                newItem.name = text
                                newItem.createdAt = Date()
                                
                                do {
                                    //saves to phone
                                    try context.save()
                                }
                                catch {
                                    print(error)
                                }
                                //closes keyboard and empties text field
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                text = ""
                            }
                        //button styling
                        }, label: {
                            Text("Add")
                                .padding(10)
                        })
                        .background(Color .green)
                        .cornerRadius(40)
                    }
                }
            }
            //list of items container
            Section {
                //For each list item in fetch request varible items
                ForEach(items) { listItem in
                    //list item container
                    VStack(alignment: .leading){
                        //display list name
                        Text(listItem.name!)
                            //sytles
                            .font(.headline)
                            .underline()
                            .foregroundColor(.green)
                        //display time created
                        Text("Created: \(listItem.createdAt!)")
                    }
                //swiftUI included delete method for swipe left delete
                }.onDelete(perform: { indexSet in
                    //finds the index of the list item
                    guard let index = indexSet.first else {
                        return
                    }
                    //creates a variable equal item at that index
                    let itemToDelete = items[index]
                    //deletes item from @envirment variable context
                    context.delete(itemToDelete)
                    do {
                        //saves
                        try context.save()
                    }
                    catch {
                        print(error)
                    }
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

