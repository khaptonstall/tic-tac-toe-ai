import Foundation
import PlaygroundSupport
import SwiftUI

/**
 A Swift playground demonstrating a minimax algorithm for playing tic-tac-toe.
 Possible improvements:
 - Reduce number of force-unwraps by gracefully handling indicies
 - Determine draws faster rather than playing out game when a winner is no longer possible.
 */

struct TicTacToeBoardGameView: View {

    @State var board = TicTacToeBoard()

    var body: some View {
        VStack {
            HStack {
                self.createButton(forIndex: 0)
                self.createButton(forIndex: 1)
                self.createButton(forIndex: 2)
            }
            HStack {
                self.createButton(forIndex: 3)
                self.createButton(forIndex: 4)
                self.createButton(forIndex: 5)
            }
            HStack {
                self.createButton(forIndex: 6)
                self.createButton(forIndex: 7)
                self.createButton(forIndex: 8)
            }

            Button("Reset") {
                self.board = TicTacToeBoard()
            }
        }.frame(width: 300, height: 300)
    }

    private func createButton(forIndex index: Int) -> some View {
        return Button(board.boardValue(forIndex: index).displayValue) {
            guard board.boardValue(forIndex: index) == .none else {
                return
            }

            self.board.makeMove(atIndex: index, forPlayer: .o)
            self.playComputerMove()
        }.frame(width: 44, height: 44)
    }

    private func playComputerMove() {
        guard board.evaluateOutcome() == nil else {
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            guard let move = minimax(board: board, player: .x).index else {
                return
            }

            DispatchQueue.main.async {
                board.makeMove(atIndex: move, forPlayer: .x)
            }
        }
    }
}

PlaygroundPage.current.setLiveView(TicTacToeBoardGameView())
