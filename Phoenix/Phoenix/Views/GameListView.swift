//
//  GameListView.swift
//  Phoenix
//
//  Created by Kaleb Rosborough on 2022-12-28.
//
import SwiftUI

struct GameListView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    
    @Binding var sortBy: PhoenixApp.SortBy

    @Binding var searchText: String
    @Binding var isAddingGame: Bool
    @State private var timer: Timer?
    @State private var minWidth: CGFloat = 296
    
    @Default(.showSortByNumber) var showSortByNumber
    @Default(.showSidebarAddGameButton) var showSidebarAddGameButton
    
    @Default(.accentColorUI) var accentColorUI
    @Default(.gradientUI) var gradientUI
    
    var body: some View {
        VStack {
            List(selection: $gameViewModel.selectedGame) {
                let favoriteGames = gameViewModel.games.filter {
                    $0.isHidden == false && ($0.name.localizedCaseInsensitiveContains(searchText) || searchText.isEmpty) && $0.isFavorite == true
                }
                if !favoriteGames.isEmpty {
                    Section(header: Text("Favorites \(showSortByNumber ? "(\(favoriteGames.count))" : "")")) {
                        ForEach(favoriteGames, id: \.id) { game in
                            GameListItem(game: game)
                        }
                    }
                }
                switch sortBy {
                case .platform:
                    ForEach(Platform.allCases, id: \.self) { platform in
                        let gamesForPlatform = gameViewModel.games.filter {
                            $0.platform == platform && $0.isHidden == false && ($0.name.localizedCaseInsensitiveContains(searchText) || searchText.isEmpty) && $0.isFavorite == false
                        }
                        if !gamesForPlatform.isEmpty {
                            Section(header: Text("\(platform.displayName) \(showSortByNumber ? "(\(gamesForPlatform.count))" : "")")) {
                                ForEach(gamesForPlatform, id: \.id) { game in
                                    GameListItem(game: game)
                                }
                            }
                        }
                    }
                case .status:
                    ForEach(Status.allCases, id: \.self) { status in
                        let gamesForStatus = gameViewModel.games.filter {
                            $0.status == status && $0.isHidden == false && ($0.name.localizedCaseInsensitiveContains(searchText) || searchText.isEmpty) && $0.isFavorite == false
                        }
                        if !gamesForStatus.isEmpty {
                            Section(header: Text("\(status.displayName) \(showSortByNumber ? "(\(gamesForStatus.count))" : "")")) {
                                ForEach(gamesForStatus, id: \.id) { game in
                                    GameListItem(game: game)
                                }
                            }
                        }
                    }
                case .name:
                    let gamesForName = gameViewModel.games.filter {
                        $0.isHidden == false && ($0.name.localizedCaseInsensitiveContains(searchText) || searchText.isEmpty) && $0.isFavorite == false
                    }.sorted(by: { $0.name < $1.name })
                    if !gamesForName.isEmpty {
                        Section(header: Text("Name")) {
                            ForEach(gamesForName, id: \.id) { game in
                                GameListItem(game: game)
                            }
                        }
                    }
                case .recency:
                    ForEach(Recency.allCases, id: \.self) { recency in
                        let gamesForRecency = gameViewModel.games.filter {
                            $0.recency == recency && $0.isHidden == false && ($0.name.localizedCaseInsensitiveContains(searchText) || searchText.isEmpty) && $0.isFavorite == false
                        }
                        if !gamesForRecency.isEmpty {
                            Section(header: Text("\(recency.displayName) \(showSortByNumber ? "(\(gamesForRecency.count))" : "")")) {
                                ForEach(gamesForRecency, id: \.id) { game in
                                    GameListItem(game: game)
                                }
                            }
                        }
                    }
                }
            }
            
            if showSidebarAddGameButton {
                Button(action: {
                    isAddingGame.toggle()
                }, label: {
                    Image(systemName: "plus.app")
                        .font(.system(size: 16))
                        .foregroundColor(Color.white)
                    Text("Add new game")
                        .foregroundColor(Color.white)
                        .font(.system(size: 15))
                })
                .buttonStyle(.plain)
                .frame(minWidth: 200, maxWidth: .infinity, maxHeight: 35)
                .background(
                    Group {
                        if gradientUI {
                            LinearGradient(
                                colors: [accentColorUI ? Color.accentColor : Color.blue,
                                         accentColorUI ? Color.accentColor.opacity(0.7) : Color.blue.opacity(0.7)],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                            .cornerRadius(7.5) // Adjust the corner radius value as needed
                        } else {
                            (accentColorUI ? Color.accentColor : Color.blue)
                                .cornerRadius(7.5) // Adjust the corner radius value as needed
                        }
                    }
                )
                .padding()
            }
        }
        .frame(minWidth: Defaults[.showPickerText] ? 296 : 245)
    }
}
