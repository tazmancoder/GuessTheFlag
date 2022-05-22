//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Mark Perryman on 5/13/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var jsonData: LoadJSONData

    @State private var showingScore = false
    @State private var showFinalScore = false
    @State private var scoreTitle = ""
    @State private var gameScore = 0
    @State private var chosenFlag = ""
    @State private var totalQuestions = 1
    @State private var howManyRight: Double = 0

    @State private var correctAnwser = Int.random(in: 0...2)
    @State private var isCorrect = false

    // Animation
    @State private var animationAmount = 0.0
    @State private var buttonOpacity = 1.0
    @State private var buttonSize = 1.0

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)

            VStack {
                Spacer()

                Text("Guess The Flag")
                    .prominentText()

                // The Game Area
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline)
                            .fontWeight(.heavy)
                            .foregroundStyle(.secondary) // This allows Virbrancy

                        Text(jsonData.countryCodes[correctAnwser].name)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                    }

                    ForEach(0..<3) { number in
                        Button(action: {
                            chosenFlag = jsonData.countryCodes[number].name
                            isCorrect = flagTapped(number)
                        }, label: {
                            FlagImage(imageName: jsonData.countryCodes[number].iso2.lowercased())
                        })
                        .rotation3DEffect(.degrees(number == correctAnwser ? animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                        .opacity(number != correctAnwser ? buttonOpacity : 1)
                        .scaleEffect(number != correctAnwser ? buttonSize : 1)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Spacer()
                Spacer()

                Text(scoreTitle)
                    .font(.headline)
                    .foregroundColor(.white)
//                    .animation(.easeInOut, value: scoreTitle)

                if !isCorrect {
                    Text(scoreTitle.contains("Wrong") ? "Thats the flag of \(chosenFlag)" : "")
                        .font(.headline)
                        .foregroundColor(.white)
                }

                Spacer()

                Text("Score: \(gameScore)")
                    .foregroundColor(.white)
                    .font(.title.bold().monospacedDigit())

                Spacer()
            }
            .padding()
        }
        .alert("Game Ended", isPresented: $showFinalScore) {
            Button(action: { resetGame() }, label: {
                Text("Start Again")
            })
        } message: {
            Text("""
            You got \(gameScore) out of 8 correct.
            Total Percentage: \(howManyRight, format: .percent)
            """)
        }
    }

    private func flagTapped(_ number: Int) -> Bool {
        var correct = false

        withAnimation(Animation.interactiveSpring(response: 1, dampingFraction: 0.5, blendDuration: 8)) {
            if number == correctAnwser {
                scoreTitle = "Correct"
                gameScore += 1
                correct = true
            } else {
                scoreTitle = "Wrong"
                gameScore -= 1
                // Make sure score never shows negative number
                if gameScore < 0 { gameScore = 0 }

                showingScore = true
                correct = false
            }

            buttonOpacity -= 0.75
            animationAmount += 360
            buttonSize -= 0.50
        }

        totalQuestions += 1

        if totalQuestions > 8 {
            if gameScore < 0 {
                // Doing this cause I dont want to divide
                // negative numbers
                gameScore = 0
            }
            howManyRight = Double(gameScore) / Double(totalQuestions) * 100.0
            showFinalScore.toggle()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                askQuestion()
            })
        }

        return correct
    }

    private func askQuestion() {
        withAnimation(Animation.interactiveSpring(response: 1, dampingFraction: 0.5, blendDuration: 8)) {
            jsonData.countryCodes.shuffle()
            correctAnwser = Int.random(in: 0...2)
            scoreTitle = ""
            animationAmount = 0
            buttonOpacity = 1
            buttonSize = 1
        }
    }

    private func resetGame() {
        jsonData.countryCodes.shuffle()
        correctAnwser = Int.random(in: 0...2)
        gameScore = 0
        howManyRight = 0
        totalQuestions = 1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct FlagImage: View {
    var imageName: String

    var body: some View {
        Image(imageName)
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: FlagConstants.widthOfFlag, height: FlagConstants.heightOfFlag)
            .cornerRadius(10)
            .shadow(radius: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 3)
            )

    }
}

struct ProminentText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
    }
}

//struct FlagAnimation: ViewModifier {
//    let amount: Double
//    let whichFlag: Int
//
//    func body(content: Content) -> some View {
//        content
//            .ro
//    }
//}
