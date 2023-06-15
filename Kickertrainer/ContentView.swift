//
//  ContentView.swift
//  Kickertrainer
//
//  Created by Dennis Kubousek on 22.03.23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: KickertrainerViewModel
    @Environment(\.colorScheme) var colorScheme
    @State var showHelpView = false
    
    var body: some View {
        
        //TODO: Make navbar or sth similar for the settings. In main view only show goalpositions, start/reset buttons and maybe random time
        
        //TODO: Try to use adaptive padding (.padding()) insted of fixed values if possible to make the apps ui more responsive to different screen sizes
        
        //TODO: Splitting up large views: we can take parts of the view out into a separate view to make it easier to understand and easier to re-use, and Xcode makes it a cinch: just Cmd-click on the "navigation link" and choose Extract Subview. This will pull the code out into a new SwiftUI view, and leave a reference where it was.

        ZStack {
                HStack{
                    VStack() {
                        Stepper {} onIncrement: {
                            viewModel.incrementCounter()
                        } onDecrement: {
                            viewModel.decrementCounter()
                        }
                        .labelsHidden()
                        .background(.gray)
                        .cornerRadius(10)
                        .padding(.top, 10.0)
                        
                        Text(String(viewModel.counter))
                            .font(.largeTitle)
                            .fontWeight(.medium)
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                            .padding(.horizontal, 10.0)
                        
                        Toggle("Zufällige Zeit",isOn: $viewModel.useRandomTime)
                            .padding(.top, -15.0)
                            .padding(.bottom, 30.0)
                            .padding(.trailing, 10.0)
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                            .frame(width: 150, height: 60, alignment: .center)
                        
                        Toggle("Doppelt auswählen",isOn: $viewModel.selectTwice)
                            .padding(.top, -15.0)
                            .padding(.bottom, 30.0)
                            .padding(.trailing, 10.0)
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                            .frame(width: 150, height: 60, alignment: .center)
                        
                        Button() {
                            viewModel.startSetupTimer()
                        } label: {
                            Text("Start")
                                .padding(.horizontal, 40)
                                .padding(.vertical, 15)
                                .foregroundColor(colorScheme == .dark ? .black : .white)
                                .background(.gray)
                                .cornerRadius(10)
                        }
                        
                        Button() {
                            viewModel.resetGoalPositions()
                            viewModel.resetTimer()
                        } label: {
                            Text("Reset")
                                .padding(.horizontal, 40)
                                .padding(.vertical, 15)
                                .foregroundColor(colorScheme == .dark ? .black : .white)
                                .background(.gray)
                                .cornerRadius(10)
                        }
                        
                        Text("Zufallszeit: ")
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                            .padding(.top, 10.0)
                        
                        if viewModel.showRandomCounter {
                            Text(String(viewModel.randomCounterToShow))
                                .fontWeight(.medium)
                                .foregroundColor(colorScheme == .dark ? .black : .white)
                        } else {
                            Text("-")
                                .fontWeight(.medium)
                                .foregroundColor(colorScheme == .dark ? .black : .white)
                        }
                    }
                    .frame(
                        minWidth: 200,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .trailing)
                    .background(colorScheme == .dark ? .white : .black)
            
                HStack{
                    ForEach(viewModel.goalPositions, id: \.self) { goalPosition in
                        PositionView(goalPosition: goalPosition)
                            .onTapGesture {
                                viewModel.toggleGoalPosition(goalPosition)
                            }
                    }
                    
                }
                .padding(.horizontal, 40.0)
                .blur(radius: viewModel.showSetupTimer ? 5 : 0)
                
            }
            
            if viewModel.showSetupTimer {
                Text(viewModel.setupCounter == 0 ? "GO" : String(viewModel.setupCounter))
                    .font(.system(size: 120))
                    .fontWeight(.bold)
            }
            VStack{
                HStack {
                    HelpButton(action: {showHelpView = true})
                        .padding(.top)
                        .padding(.leading)
                    Spacer()
                }
                Spacer()
            }
            if showHelpView == true {
                HelpView(showHelpView: $showHelpView)
            }
        }
    }
}

struct PositionView: View {
    let goalPosition: GoalPosition
    var body: some View {
        VStack{
            Text(goalPosition.name)
                .font(.largeTitle)
                .frame(width: 100, height: 100)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(!goalPosition.isSelected ? goalPosition.isActive ? Color.green : Color.gray : Color.red))
                
        }
    }
}

struct HelpView: View {
    @State var showHelpView: Binding<Bool>
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack {
            ScrollView {
                Text("""
Über die Plus- bzw. Minusbuttons kann eine Zeit zwischen 1 Sekunde und 15 Sekunde eingestellt werden.

Ist der Slider 'Zufällige Zeit' an, dann wird beim Start ein zufälliger Countdown zwischen 1 Sekunde und der oben ausgewählten Zeit gestartet.

Ist der Slider 'Zufällige Zeit' aus, dann wird beim Start ein Countdown mit dem oben ausgewählten Wert gestartet.

Die Torposition (1-5) können mit einem Klick aktiviert (grün) bzw. deaktiviert (grau) werden.

Aus den aktiven Positionen wird nach Ablauf des Countdowns eine Position zufällig ausgewählt (rot).

Vor dem echten Countdown wird ein kurzer Countdown (3,2,1,GO) gestartet um genügend Zeit für das Schusssetup zu gewährleisten.
""")
            }
            .padding(.leading, 40)
            .padding(.top)
            
            Spacer()
            HStack {
                Button() {
                    showHelpView.wrappedValue = false
                } label: {
                    Spacer()
                    
                    Text("Close")
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .background(.gray)
                        .cornerRadius(10)
                    
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colorScheme == .dark ? .black : .white)
    }
}

struct HelpButton: View {
    var action : () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: action, label: {
            ZStack {
                Circle()
                    .strokeBorder(.gray, lineWidth: 0.5)
                    .background(Circle().foregroundColor(colorScheme == .dark ? .black : .white))
                    .shadow(color: Color(.gray).opacity(0.3), radius: 1)
                    .frame(width: 30, height: 30)
                Text("?").font(.system(size: 15, weight: .medium ))
            }
        })
        .buttonStyle(PlainButtonStyle())
    }
}
    
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let kickertrainer = KickertrainerViewModel()
        ContentView(viewModel: kickertrainer)
    }
}

