//
//  ScheduleView.swift
//  DeepDishLie
//
//  Created by Morten Bjerg Gregersen on 24/04/2024.
//

import SwiftUI

struct ScheduleView: View {
    @Environment(ScheduleController.self) private var scheduleController
    
    var body: some View {
        NavigationStack {
            List(scheduleController.days) { day in
                Section {
                    ForEach(day.events) { event in
                        HStack(alignment: .top) {
                            VStack {
                                Text(event.start.formatted(date: .omitted, time: .shortened))
                                Text(event.end.formatted(date: .omitted, time: .shortened))
                            }
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.accentColor)
                            VStack(alignment: .leading) {
                                Text(event.description)
                                    .font(.headline)
                                if let speakers = event.speakers {
                                    Text(ListFormatter.localizedString(byJoining: speakers.map(\.name)))
                                }
                            }
                            if let speakers = event.speakers {
                                Spacer()
                                ForEach(speakers) { speaker in
                                    Image(speaker.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50)
                                        .clipShape(Circle())
                                }
                            }
                        }
                    }
                } header: {
                    Text(day.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.accentColor)
                }
            }
            .listStyle(.inset)
            .navigationTitle("Schedule")
            .toolbarBackground(Color.accentColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

#Preview {
    ScheduleView()
        .environment(ScheduleController.forPreview())
}
