//
//  ContentView.swift
//  task-list
//
//  Created by Michał Droś on 25/12/2024.
//

import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    var name: String
    var isCompleted: Bool
}

struct ContentView: View {
    @State private var tasks: [Task] = [
        Task(name: "Task 1", isCompleted: false),
        Task(name: "Task 2", isCompleted: false),
        Task(name: "Task 3", isCompleted: false)
    ]
    
    var body: some View {
        NavigationView {
            List {
                ForEach($tasks) { $task in
                    HStack {
                        Button(action: {
                            task.isCompleted.toggle()
                        }) {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isCompleted ? .green : .gray)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        Text(task.name)
                            .strikethrough(task.isCompleted, color: .gray)
                            .foregroundColor(task.isCompleted ? .gray : .primary)
                    }
                }
                .onDelete(perform: deleteTask)
            }
            .navigationTitle("Tasks")
            .toolbar {
                EditButton()
            }
        }
    }
    
    private func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
