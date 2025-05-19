import SwiftUI
import MapKit
import MultipeerConnectivity

enum AnswerState {
    case correct, incorrect, neutral
}

struct IndexView: View {
    @State private var currentLocationIndex = 0
    @State private var currentQuestionIndex = 0
    @State private var answerText = ""
    @State private var answerState: AnswerState = .neutral
    @State private var timeRemaining = 15
    @State private var timer: Timer?
    @State private var showNextButton = false
    @State private var navigateToCongratulations = false
    
    @State private var players: [Player] = [Player(name: "Player 1"), Player(name: "Player 2")]
    @State private var currentPlayerIndex = 0
    
    @StateObject private var multipeerSession = MultipeerSession()

    let locations: [Location] = Bundle.main.decode("locations.json")

    var body: some View {
        ZStack {
            Map(coordinateRegion: .constant(
                MKCoordinateRegion(
                    center: locations[currentLocationIndex].coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                )
            ))
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                playerScoresView
                questionInputView
                Spacer()
            }
            .padding()
        }
        .onAppear {
            startTimer()

            NotificationCenter.default.addObserver(forName: .didReceiveGameState, object: nil, queue: .main) { notification in
                guard let data = notification.object as? Data else { return }
                receiveGameState(data)
            }
        }

        .background(
            NavigationLink(destination: CongratulationsView(playerScores: players), isActive: $navigateToCongratulations) {
                EmptyView()
            }
        )
    }

    var playerScoresView: some View {
        HStack {
            ForEach(players.indices, id: \.self) { index in
                playerScoreCard(for: index)
            }
        }
    }
    
    func receiveGameState(_ data: Data) {
        do {
            let receivedState = try JSONDecoder().decode(GameState.self, from: data)
            currentLocationIndex = receivedState.currentLocationIndex
            currentQuestionIndex = receivedState.currentQuestionIndex
            players = receivedState.players
            currentPlayerIndex = receivedState.currentPlayerIndex
            answerText = ""
            answerState = .neutral
            showNextButton = false
            timeRemaining = 15
        } catch {
            print("Failed to decode received game state: \(error.localizedDescription)")
        }
    }
    
    func sendCurrentGameState() {
        let gameState = GameState(
            currentLocationIndex: currentLocationIndex,
            currentQuestionIndex: currentQuestionIndex,
            players: players,
            currentPlayerIndex: currentPlayerIndex
        )
        multipeerSession.send(gameState: gameState)
    }


    func playerScoreCard(for index: Int) -> some View {
        VStack {
            Text(players[index].name)
                .font(.caption)
                .foregroundColor(.white)
            Text("\(players[index].score)")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding(10)
        .background(index == currentPlayerIndex ? Color.green : Color.gray.opacity(0.5))
        .cornerRadius(10)
    }


    var questionInputView: some View {
        VStack(spacing: 10) {
            Text("Time Remaining: \(timeRemaining)")
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(10)

            Text("\(players[currentPlayerIndex].name)'s Turn")
                .font(.headline)
                .foregroundColor(.white) // changed from .white
                .padding(.bottom, 10)

            Text(locations[currentLocationIndex].questions[currentQuestionIndex].question)
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.7))
                .cornerRadius(10)

            TextField("Enter your answer", text: $answerText, onCommit: checkAnswer)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .foregroundColor(.black) // ensures typed text is black
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(answerState == .correct ? Color.green : (answerState == .incorrect ? Color.red : Color.clear), lineWidth: 2)
                )
                .padding()

            if showNextButton {
                Button("Next Question", action: nextQuestion)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }

    func checkAnswer() {
        timer?.invalidate()
        let correctAnswer = locations[currentLocationIndex].questions[currentQuestionIndex].answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let userAnswer = answerText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        if userAnswer == correctAnswer {
            answerState = .correct
            players[currentPlayerIndex].score += 1000
        } else {
            answerState = .incorrect
        }

        showNextButton = true
        sendCurrentGameState()
    }

    func nextQuestion() {
        showNextButton = false
        answerText = ""
        answerState = .neutral
        currentQuestionIndex += 1

        if currentQuestionIndex >= locations[currentLocationIndex].questions.count {
            currentQuestionIndex = 0
            currentLocationIndex = (currentLocationIndex + 1) % locations.count
        }

        if currentLocationIndex == 0 && currentQuestionIndex == 0 {
            navigateToCongratulations = true
            return
        }

        currentPlayerIndex = (currentPlayerIndex + 1) % players.count
        startTimer()
        sendCurrentGameState()
    }

    func startTimer() {
        timer?.invalidate()
        timeRemaining = 15

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            timeRemaining -= 1
            if timeRemaining <= 0 {
                timer?.invalidate()
                answerState = .incorrect
                showNextButton = true
            }
        }
    }
}
