import Foundation

/**
 A Swift playground demonstrating a minimax algorithm for playing tic-tac-toe.
 Possible improvements:
 - Split code into multiple files for easier maintainablility
 - Reduce number of force-unwraps by gracefully handling indicies
 - Add UI for a human player
 - Determine draws faster rather than playing out game when a winner is no longer possible.
 */

enum BoardValue {
    case x
    case o
    case none

    var displayValue: String {
        switch self {
        case .x:
            return "X"
        case .o:
            return "O"
        case .none:
            return "-"
        }
    }
}

enum Player {
    case x
    case o
}

typealias Board = [BoardValue]
var board: Board = Array(repeating: BoardValue.none, count: 9)

func findAvailableMoves(onBoard board: Board) -> [Int] {
    return board
        .enumerated()
        .filter { $0.element == .none }
        .map { $0.offset }
}

enum Outcome {
    case x
    case o
    case draw
}

typealias IndexSeries = (Int, Int, Int)
let winningIndicies: [IndexSeries] = [
    // Winning by row
    (0, 1, 2),
    (3, 4, 5),
    (6, 7, 8),
    // Winning by column
    (0, 3, 6),
    (1, 4, 7),
    (2, 5, 8),
    // Winning by diagonal
    (0, 4, 7),
    (2, 4, 6)
]

func evaluateOutcome(forBoard board: Board) -> Outcome? {
    for indicies in winningIndicies {
        let values = [board[indicies.0], board[indicies.1], board[indicies.2]]
        switch values {
        case [.x, .x, .x]:
            return .x
        case [.o, .o, .o]:
            return .o
        default:
            continue
        }
    }

    if !board.contains(.none) {
        return .draw
    } else {
        return nil
    }
}

struct Move {
    var index: Int?
    var value: Int
}

/// A cache of board game states to values of that state for the maximizing player.
var xCache: [Board: Int] = [:]

/// A cache of board game states to values of that state for the minimizing player.
var oCache: [Board: Int] = [:]

func minimax(board: Board, player: Player) -> Move {
    // Grab all available moves.
    let moves = findAvailableMoves(onBoard: board)

    // Determine if the game has ended. If so, assign a value for the outcome where
    // the number of remaining moves positively influences the score for the given player.
    if let outcome = evaluateOutcome(forBoard: board) {
        switch outcome {
        case .o:
            return Move(index: nil, value: -1 * moves.count)
        case .x:
            return Move(index: nil, value: 1 * moves.count)
        case .draw:
            return Move(index: nil, value: 0)
        }
    }


    switch player {
    case .x:
        // Maximizing player.
        var value = Int.min
        var bestMove = moves[0]
        for move in moves {
            var updatedBoard = board
            updatedBoard[move] = .x

            let moveValue: Int
            if let cachedValue = xCache[updatedBoard] {
                moveValue = cachedValue
            } else {
                moveValue = minimax(board: updatedBoard, player: .o).value
                xCache[updatedBoard] = moveValue
            }

            if moveValue > value {
                value = moveValue
                bestMove = move
            }
        }

        return Move(index: bestMove, value: value)
    case .o:
        // Minimizing player.
        var value = Int.max
        var bestMove = moves[0]
        for move in moves {
            var updatedBoard = board
            updatedBoard[move] = .o

            let moveValue: Int
            if let cachedValue = oCache[updatedBoard] {
                moveValue = cachedValue
            } else {
                moveValue = minimax(board: updatedBoard, player: .x).value
                oCache[updatedBoard] = moveValue
            }

            if moveValue < value {
                value = moveValue
                bestMove = move
            }
        }

        return Move(index: bestMove, value: value)
    }
}

func printBoard() {
    let displayableBoard = board.map { $0.displayValue }
    print("\(displayableBoard[0]) \(displayableBoard[1]) \(displayableBoard[2])")
    print("\(displayableBoard[3]) \(displayableBoard[4]) \(displayableBoard[5])")
    print("\(displayableBoard[6]) \(displayableBoard[7]) \(displayableBoard[8])")

    print("*************")
}

/// Plays through an automated game of TicTacToe, running a minimax algorithm for each player,
/// where X is the maximizing player and O is the minimizing player.
func playTicTacToe() {
    var currentPlayer = Player.x
    while evaluateOutcome(forBoard: board) == nil {
        printBoard()

        // For each turn find the best move, play it, then switch over to the other player.
        switch currentPlayer {
        case .o:
            let move = minimax(board: board, player: currentPlayer).index!
            board[move] = .o
            currentPlayer = .x
        case .x:
            let move = minimax(board: board, player: currentPlayer).index!
            board[move] = .x
            currentPlayer = .o
        }
    }

    printBoard()

    switch evaluateOutcome(forBoard: board)! {
    case .o:
        print("O won...")
    case .x:
        print("X won!")
    case .draw:
        print("It's a draw.")
    }
}

playTicTacToe()
