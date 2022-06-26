//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Eric Di Gioia on 6/15/22.
//

import CodeScanner
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    enum SortType {
        case name, recent
    }
    
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    
    @State private var isShowingSortConfirmationDialog = false
    
    let filter: FilterType
    @State private var sortMethod: SortType = .recent // @State because changing it will require a UI update after, defaults to .recent here (I was lazy)
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                        
                        if filter == .none && prospect.isContacted {
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .swipeActions {
                        if prospect.isContacted {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                            
                            Button {
                                addNotification(for: prospect)
                            } label: {
                                Label("Remind me", systemImage: "bell")
                            }
                            .tint(.orange)
                        }
                    }
                }
            }
                .navigationTitle(title)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button {
                            isShowingSortConfirmationDialog = true
                        } label: {
                            Label("Sort contacts", systemImage: "arrow.up.arrow.down")
                        }
                        
                        Button {
                            isShowingScanner = true
                        } label: {
                            Label("Scan", systemImage: "qrcode.viewfinder")
                        }
                    }
                }
                .sheet(isPresented: $isShowingScanner) {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "Paul Hudson\npaul@hackingwithswift.com", completion: handleScan)
                }
                .confirmationDialog("Choose contact sort method", isPresented: $isShowingSortConfirmationDialog) {
                    Button("Sort by name") {
                        sortMethod = .name
                    }
                    
                    Button("Sort by most recent") {
                        sortMethod = .recent
                    }
                } message: {
                    Text("Choose contact sort method")
                }
        }
    }
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        var people: [Prospect]
        
        // first filter which contacts to show
        switch filter {
        case .none:
            people = prospects.people
        case .contacted:
            people = prospects.people.filter { $0.isContacted }
        case .uncontacted:
            people = prospects.people.filter { !$0.isContacted }
        }
        
        // next sort those contacts
        switch sortMethod {
        case .name:
            people = people.sorted {
                $0.name < $1.name
            }
        case .recent:
            break // default sort method; no additional sorting required
        }
        
        return people
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return } // make sure we scan in only two strings
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            prospects.add(person)
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9 // 9:00
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false) // should be notified the next 9:00
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // show notification in 5 sec (test purposes)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("Error")
                    }
                }
            }
        }
    }
    
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
