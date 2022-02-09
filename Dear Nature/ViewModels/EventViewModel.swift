//
//  EventViewModel.swift
//  Dear Nature
//
//  Created by Robin Xia on 2022-02-07.
//

import Foundation

class EventViewModel : ObservableObject {
    
    @Published var events = [Event]()
    
    func addMockData() {
        events.append(Event(title: "Whooper Swan Migration", date: "February-Mars 2022", image: "whooperswan"))
        events.append(Event(title: "Wild Strawberries (Smultron)", date: "June-August 2022", image: "wildstrawberry"))
        events.append(Event(title: "Blueberries", date: "July-August 2022", image: "blueberry"))
        events.append(Event(title: "Raspberries", date: "July-September 2022", image: "hallon"))
    }
    
    init() {
        addMockData()
    }
    
}
