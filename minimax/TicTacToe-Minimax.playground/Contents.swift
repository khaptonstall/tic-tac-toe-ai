import Foundation

/**
 A Swift playground demonstrating a minimax algorithm for playing tic-tac-toe.
 Possible improvements:
 - Reduce number of force-unwraps by gracefully handling indicies
 - Add UI for a human player
 - Determine draws faster rather than playing out game when a winner is no longer possible.
 */

/// The tic tac toe game board.
var board = TicTacToeBoard()

/// Plays through an automated game of TicTacToe, running a minimax algorithm for each player,
/// where X is the maximizing player and O is the minimizing player.
func playMinimaxTicTacToe() {
    var currentPlayer = Player.x
    while board.evaluateOutcome() == nil {
        board.printBoard()

        // For each turn find the best move, play it, then switch over to the other player.
        switch currentPlayer {
        case .o:
            let move = minimax(board: board, player: currentPlayer).index!
            board.makeMove(atIndex: move, forPlayer: .o)
            currentPlayer = .x
        case .x:
            let move = minimax(board: board, player: currentPlayer).index!
            board.makeMove(atIndex: move, forPlayer: .x)
            currentPlayer = .o
        }
    }

    board.printBoard()

    switch board.evaluateOutcome()! {
    case .o:
        print("O won...")
    case .x:
        print("X won!")
    case .draw:
        print("It's a draw.")
    }
}

playMinimaxTicTacToe()
