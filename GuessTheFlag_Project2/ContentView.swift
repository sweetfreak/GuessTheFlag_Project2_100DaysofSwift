//
//  ContentView.swift
//  GuessTheFlag_Project2
//
//  Created by Jesse Sheehan on 7/24/24.
//

import SwiftUI

struct flagImage: View {
    var flag: String
    
        var body: some View {
            Image(flag)
                .clipShape(.capsule)
                .shadow(color: .white, radius: 7)
        }
}



struct ContentView: View {
    
   @State private var countries = ["Estonia", "Germany", "Poland", "France", "Ireland", "Italy", "Nigeria", "Spain", "UK", "US", "Ukraine"].shuffled()
    //shuffled() randomizes the array!
    
    let labels = [
        "Estonia":"Flag with three horizontal stripes. Top stripe blue, middle stripe black, bottom strip white",
        "Germany":"Flag with three vertical stripes. Top Strip black, middle stripe red, bottom stripe gold",
        "Poland":"Flag with two horizontral strips. Top stripe white, bottom strip red",
        "France":"Flag with three vertical stripes. Left Stripe blue, middle strip white, right stripe red",
        "Ireland":"Flag with three vertical stripes. Left strip green, middle strip white, right stripe orange",
        "Italy":"Flag with three vertical stripes. Left strip green, middle strip white, right stripe red",
        "Nigeria":"Flag with three vertical stripes. Left strip green, middle strip white, right stripe green",
        "Spain":"Flag with three horizontal stripes. Top thin stripe red, middle thick stripe is cold with crest on the left, botton thing strip is red",
        "UK":"Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US":"Flag with many alternating red and white stripes, with white stars on a blue background in the top-left corner",
        "Ukraine":"Flag with two horizontal strips. Top stripe blue, bottom stripe yellow",
    ]
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
  
    @State private var score = 0
    
    @State private var questionsAsked = 0
    private var totalNumOfQuestions = 8
    @State private var gameOver = false
    @State private var gameResult = "Game is over!"

    private var winningScore = 60
    private var correctAnswerPoints = 10
    private var losingAnswerPoints = -5
    
    //project6Challenge
    //"animation amount"
    @State private var flagSpinAmount = 1.0
    @State private var opacityAmount = 0.0
    
    var body: some View {
        ZStack {
            //            LinearGradient(colors: [.blue, .white], startPoint: .top, endPoint: .bottom)
            //                .ignoresSafeArea()
            
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess! the! Flag!")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                
                VStack(spacing: 15){
                    
                    VStack {
                        Text("Tap the flag of:")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    //
                    
                    ForEach(0..<3) {number in
                        Button {
                                withAnimation(.spring(duration:1, bounce: 0.4)){
                                    flagSpinAmount += 360
                                }
                            flagTapped(number)
                        } label: {
                            flagImage(flag: countries[number])
                                .rotation3DEffect(
                                    .degrees(number == correctAnswer ? flagSpinAmount : 0),
                                    axis: (x: 0.0, y: 1.0, z: 0.0)
                                )
                                .animation(.default, value: showingScore)
                                .opacity((showingScore && number != correctAnswer) ? 0.25 : 1)
                                .animation(.easeOut(duration: 1), value: showingScore)
                                
                        }
                        .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                       
                    
                               
                        
                    }
                }
                .frame(maxWidth: .infinity) // don't need max height, it jsut fits what we need
                .padding(.vertical, 25) //adds space above/below
                .background(.regularMaterial) //creates the glass look
                .clipShape(.rect(cornerRadius: 20)) //rounds corners
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
                
            }
            .padding()
            
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score) \n. Questions Left: \(totalNumOfQuestions - questionsAsked)")
        }
        
        .alert(gameResult, isPresented: $gameOver) {
            Button("Play Again", action: resetGame)
        } message: {
            if score >= winningScore {
                Text("Your winning score was \(score)")
            } else {
                Text("Your score: \(score) \n You need 60 or more to win.")
            }
        }
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += correctAnswerPoints
        } else {
            scoreTitle = "No, IDIOT, that's \(countries[number])"
            //number = tappedFlag
            score -= losingAnswerPoints
        }
        
        questionsAsked += 1
        
        if questionsAsked != totalNumOfQuestions {
            showingScore = true
        } else {
            gameOver = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
    }
    
    func resetGame() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionsAsked = 0
        score = 0
    }
    
}



//    //track when the alert is shown
//    @State private var showingAlert = false
//    @State private var showing2ndAlert = false

//  Button("Show Alert") {
//            showingAlert = true
//        }
//        .padding()
//        //two way binding of showingAlert so it can be set to false again
//        .alert("Deleting photos now", isPresented: $showingAlert) {
//            Button("Delete", role: .destructive) { }
//            Button("Oh", role: .cancel) { }
//        } message: {
//                Text("You'll lose these memories forever")
//            }


//struct ContentView: View {
//    var body: some View {
//            VStack {
//                Button("Button1",  action: executeDelete).buttonStyle(.bordered)
//                    
//                Button {
//                    print("Button2")
//                } label: {
//                    Image(systemName: "pencil.circle.fill")
//                        .padding(50)
//                        .foregroundStyle(.white)
//                        .background(.blue)
//                        .cornerRadius(6)
//                }
//                
//                Button("Button3",  action: executeDelete).buttonStyle(.borderedProminent)
//                    .tint(.indigo)
//                
//                Button("Button4", role: .destructive,  action: executeDelete).buttonStyle(.borderedProminent)
//                
//                Button {
//                    print("Button was tapped")
//                } label: {
//                    Text("Tap THIS one!!!")
//                        .padding()
//                        .foregroundStyle(.white)
//                        .background(.orange)
//                        .cornerRadius(6)
//                }
//                
//                //dedicated image type!
//                //Adds image in from assets folder
//                //needs to be resized
//                //image
//                //Image(decorative: "JesseGarbage")
//                
//                //pictures of apple's SFSymbols catalog
//                Image(systemName: "pencil.circle")
//                    .foregroundColor(.blue)
//                    .font(.largeTitle)
//                Button("These aren't buttons", systemImage: "trash.square") {
//                    print("this is a button")
//                }
//                
//                Button {
//                    print("Use the \"Label\" property as a best practice")
//                } label: {
//                    Label("<-- Pencil", systemImage: "pencil")
//                }
//                .padding()
//                    .foregroundStyle(.yellow)
//                    .background(.pink)
//                    .cornerRadius(25)
//            }
//            
//        }
//    }
// //role: .destructive turns the button red!
// //role:
//
//func executeDelete() {
//    print("Now Deleting Everything")
//
//}


        

//simplest gradient, with no control
//        Text("Jesse")
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .foregroundStyle(.white)
//            .background(.indigo.gradient)

//LINEAR gradient
//        LinearGradient(stops: [
//            //Gradient.Stop OR .init
//            .init(color: .white, location: 0.2),
//            Gradient.Stop(color: .black, location: 0.78)
           
//        ], startPoint: .top, endPoint: .bottom)

//RADIAL GRADIENT
//        RadialGradient(colors: [.blue, .yellow], center: .center, startRadius: 20, endRadius: 200)
        
//ANGULAR Gradient
//        AngularGradient(colors: [.red, .orange, .yellow, .green, .blue, .indigo, .purple, .red], center: .center) // can do gradient stops here, too
        
        
       // LinearGradient(colors: [.white, .black], startPoint: .top, endPoint: .bottom)
  




//Color.primary - black orwhite, depending on dark/lightmode
//Color.secondary - black with half opacity

//Color(red: 1, green: 0.8, blue:0) - yellow!
//.ignoreSafeArea() - can expand available space - okay for color backgrounds, BAD for most other contact

//ZStack {
//    VStack(spacing: 0) {
//        Color.red
//        Color.blue
//    }
//    
//    Text("Jesse Sheehan")
//        .foregroundStyle(.secondary)
//        .padding(50)
//        .background(.ultraThinMaterial)
//        .cornerRadius(10.0)
//}
//.ignoresSafeArea()


#Preview {
    ContentView()
}
