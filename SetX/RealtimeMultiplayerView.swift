import SwiftUI

struct RealtimeMultiplayerView: View {
    @ObservedObject var viewModel: SetGameViewModel
    @State private var playerName: String = ""
    @State private var gameName: String = ""
    @State private var isCreatingGame = false
    @State private var isJoiningGame = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showInviteOptions = false
    @State private var showShareSheet = false
    
    var body: some View {
        ZStack {
            // Achtergrond
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0.9), Color(red: 0.1, green: 0.1, blue: 0.3)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Welkomstboodschap
                VStack(spacing: 10) {
                    Text("Let's Play Together! 🎮")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .shadow(color: .blue, radius: 10, x: 0, y: 0)
                    
                    Text("Invite your friends for a fun game of SET")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 40)
                
                // Speler naam invoer
                VStack(alignment: .leading, spacing: 5) {
                    Text("Your Name")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    TextField("Enter your name", text: $playerName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.title2)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(15)
                }
                .padding(.horizontal, 40)
                
                // Game naam invoer
                VStack(alignment: .leading, spacing: 5) {
                    Text("Game Name")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    TextField("Enter a fun game name", text: $gameName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.title2)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(15)
                }
                .padding(.horizontal, 40)
                
                // Nieuwe game maken
                Button(action: createGame) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Create New Game")
                    }
                    .font(.title2.bold())
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                }
                .padding(.horizontal, 40)
                .disabled(playerName.isEmpty || gameName.isEmpty)
                .opacity(playerName.isEmpty || gameName.isEmpty ? 0.5 : 1.0)
                
                // Of
                Text("OR")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.7))
                
                // Join bestaande game
                Button(action: joinGame) {
                    HStack {
                        Image(systemName: "person.2.fill")
                        Text("Join Friend's Game")
                    }
                    .font(.title2.bold())
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                }
                .padding(.horizontal, 40)
                .disabled(playerName.isEmpty)
                .opacity(playerName.isEmpty ? 0.5 : 1.0)
                
                Spacer()
                
                // Terug knop
                Button(action: {
                    viewModel.spelFase = .startScherm
                }) {
                    HStack {
                        Image(systemName: "arrow.left")
                        Text("Back to Menu")
                    }
                    .font(.headline)
                    .padding()
                    .background(Color.gray.opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.bottom, 40)
            }
            
            // Error overlay
            if showError {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .overlay(
                        VStack {
                            Text("Oops! 😅")
                                .font(.title)
                                .foregroundColor(.red)
                            Text(errorMessage)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                            Button("OK") {
                                showError = false
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(20)
                    )
            }
            
            // Invite overlay
            if showInviteOptions {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .overlay(
                        VStack(spacing: 20) {
                            Text("Invite Friends")
                                .font(.title)
                                .foregroundColor(.white)
                            
                            Text("Share this game with your friends!")
                                .foregroundColor(.white.opacity(0.8))
                            
                            HStack(spacing: 20) {
                                Button(action: {
                                    // TODO: Implementeer iMessage sharing
                                    showShareSheet = true
                                }) {
                                    VStack {
                                        Image(systemName: "message.fill")
                                            .font(.system(size: 40))
                                        Text("iMessage")
                                    }
                                    .foregroundColor(.white)
                                }
                                
                                Button(action: {
                                    // TODO: Implementeer AirDrop sharing
                                    showShareSheet = true
                                }) {
                                    VStack {
                                        Image(systemName: "airplayaudio")
                                            .font(.system(size: 40))
                                        Text("AirDrop")
                                    }
                                    .foregroundColor(.white)
                                }
                            }
                            
                            Button("Close") {
                                showInviteOptions = false
                            }
                            .padding()
                            .background(Color.gray.opacity(0.5))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(20)
                    )
            }
        }
    }
    
    private func createGame() {
        if playerName.isEmpty {
            errorMessage = "Please enter your name"
            showError = true
            return
        }
        if gameName.isEmpty {
            errorMessage = "Please enter a game name"
            showError = true
            return
        }
        isCreatingGame = true
        showInviteOptions = true
        // TODO: Implementeer game creatie logica
    }
    
    private func joinGame() {
        if playerName.isEmpty {
            errorMessage = "Please enter your name"
            showError = true
            return
        }
        isJoiningGame = true
        // TODO: Implementeer game join logica
    }
}

#Preview {
    RealtimeMultiplayerView(viewModel: SetGameViewModel())
} 