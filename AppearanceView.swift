//
//  AppearanceView.swift
//  Flashcard
//
//  Created by Benjamin Keller on 9/28/25.
//

import SwiftUI

enum AppearanceOption: String, CaseIterable, Identifiable {
    case system = "system"
    case light = "light"
    case dark = "dark"

    var id: String { rawValue }
    var label: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

struct AppearanceView: View {
    @AppStorage("appearance") private var appearance: String = AppearanceOption.system.rawValue

    var body: some View {
        Form {
            Section(header: Text("Appearance")) {
                Picker("Appearance", selection: $appearance) {
                    // Show only Light and Dark in the UI; keep System as a possible stored value
                    ForEach(AppearanceOption.allCases.filter { $0 != .system }) { option in
                        Text(option.label).tag(option.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section(header: Text("Info")) {
                Text("System: follows iOS appearance. Light/Dark: forces a color scheme for the app.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Appearance")
    }
}

// Preview
#if DEBUG
struct AppearanceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { AppearanceView() }
    }
}
#endif
