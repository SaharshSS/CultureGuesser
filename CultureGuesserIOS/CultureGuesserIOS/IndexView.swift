import SwiftUI
import MapKit

struct Question: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
    let type: String
    let options: [String]?
    let hint: String?
}

extension Color {
    static let customGreen = Color(red: 76/255, green: 175/255, blue: 80/255)
}

struct LocationData {
    let coordinate: CLLocationCoordinate2D
    let questions: [Question]
}

struct IndexView: View {
    @State private var score = 0
    @State private var currentLocationIndex = 0
    @State private var currentQuestionIndex = 0
    @State private var answerText = ""
    @State private var showNextButton = false
    @State private var timerProgress: CGFloat = 1.0
    @State private var timeLeft = 60.0
    @State private var timer: Timer?
    @State private var answerState: AnswerState = .neutral
    @State private var navigateToCongrats = false

    enum AnswerState {
        case correct, incorrect, neutral
    }

    let locations: [LocationData] = [
        LocationData(
            coordinate: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
            questions: [
                Question(question: "What city is this?", answer: "new york", type: "text", options: nil, hint: "The Big Apple")
            ]
        )
    ]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                Map(position: .constant(MapCameraPosition.region(MKCoordinateRegion(
                    center: locations[currentLocationIndex].coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                ))))
                .ignoresSafeArea()

                VStack(spacing: 16) {
                    Rectangle()
                        .fill(timerColor(for: timeLeft))
                        .frame(height: 10)
                        .scaleEffect(x: timerProgress, anchor: .leading)
                        .animation(.linear(duration: 0.1), value: timerProgress)

                    Spacer()

                    VStack(alignment: .leading, spacing: 12) {
                        Text(currentQuestion().question)
                            .font(.headline)
                            .foregroundColor(.black)

                        TextField("Type your answer here...", text: $answerText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(10)
                            .background(answerBackgroundColor())
                            .cornerRadius(8)
                            .onChange(of: answerText) { newValue in
                                checkAnswer(newValue)
                            }

                        if showNextButton {
                            Button("Next") {
                                nextQuestion()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.95))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    HStack(spacing: 20) {
                        Button(action: skipQuestion) {
                            Label("Skip", systemImage: "forward.fill")
                                .frame(minWidth: 100)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: openLookAround) {
                            Label("Look Around", systemImage: "binoculars.fill")
                                .frame(minWidth: 140)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding(.bottom)
                }
                .onAppear {
                    startTimer()
                }

                // Score display at top right
                VStack(alignment: .trailing) {
                    HStack {
                        Spacer()
                        VStack {
                            Text("Score")
                                .font(.caption)
                                .foregroundColor(.white)
                            Text("\(score)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding(10)
                        .background(Color.customGreen.opacity(0.8))
                        .cornerRadius(10)
                        .padding()
                    }
                    Spacer()
                }

                // DONE button top left
                VStack {
                    HStack {
                        Button("Done") {
                            navigateToCongrats = true
                        }
                        .padding(10)
                        .background(Color.customGreen.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                        Spacer()
                    }
                    Spacer()
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $navigateToCongrats) {
                CongratulationsView()
            }
        }
    }

    func currentQuestion() -> Question {
        locations[currentLocationIndex].questions[currentQuestionIndex]
    }

    func checkAnswer(_ userAnswer: String) {
        let trimmed = userAnswer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let correct = currentQuestion().answer.lowercased()

        if trimmed == correct {
            score += 1000
            showNextButton = true
            answerState = .correct
        } else if trimmed.count > 1 {
            answerState = .incorrect
            showNextButton = false
        } else {
            answerState = .neutral
        }
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

        startTimer()
    }

    func skipQuestion() {
        nextQuestion()
    }

    func startTimer() {
        timer?.invalidate()
        timeLeft = 60
        timerProgress = 1.0

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            timeLeft -= 0.1
            timerProgress = CGFloat(timeLeft / 60.0)

            if timeLeft <= 0 {
                timer?.invalidate()
                nextQuestion()
            }
        }
    }

    func timerColor(for time: Double) -> Color {
        if time <= 5 {
            return .red
        } else if time <= 15 {
            return .orange
        } else if time <= 30 {
            return .yellow
        } else {
            return .green
        }
    }

    func answerBackgroundColor() -> Color {
        switch answerState {
        case .correct: return Color.green.opacity(0.3)
        case .incorrect: return Color.red.opacity(0.3)
        case .neutral: return Color.gray.opacity(0.1)
        }
    }

    func openLookAround() {
        let coordinate = locations[currentLocationIndex].coordinate
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Explore Location"
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: coordinate),
            MKLaunchOptionsMapTypeKey: MKMapType.standard.rawValue
        ])
    }
    
    
}
