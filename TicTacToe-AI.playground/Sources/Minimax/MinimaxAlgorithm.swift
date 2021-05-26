import Foundation

public struct Move {
    /// The index of the given move. May be `nil` if their are no moves remaining.
    public var index: Int?
    /// The value of the given move.
    var value: Int
}

/// A cache of board game states to values of that state for the maximizing player.
var xCache: [TicTacToeBoard: Int] = [:]

/// A cache of board game states to values of that state for the minimizing player.
var oCache: [TicTacToeBoard: Int] = [:]

public func minimax(board: TicTacToeBoard, player: Player) -> Move {
    // Grab all available moves.
    let moves = board.availableMoves()

    // Determine if the game has ended. If so, assign a value for the outcome where
    // the number of remaining moves positively influences the score for the given player.
    if let outcome = board.evaluateOutcome() {
        switch outcome {
        case .o:
            return Move(index: nil, value: min(-1 * moves.count, -1))
        case .x:
            return Move(index: nil, value: max(1 * moves.count, 1))
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
            updatedBoard.makeMove(atIndex: move, forPlayer: .x)

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
            updatedBoard.makeMove(atIndex: move, forPlayer: .o)

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
