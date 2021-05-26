import Foundation

public struct TicTacToeBoard: Hashable {

    // MARK: BoardValue

    public enum BoardValue {
        case x
        case o
        case none

        public var displayValue: String {
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

    // MARK: Properties

    public typealias Board = [BoardValue]
    private var board: Board = Array(repeating: BoardValue.none, count: 9)

    // MARK: Initialization

    public init() {}

    // MARK: Finding and Making Moves

    public func availableMoves() -> [Int] {
        return board
            .enumerated()
            .filter { $0.element == .none }
            .map { $0.offset }
    }

    public mutating func makeMove(atIndex index: Int, forPlayer player: Player) {
        board[index] = player == .x ? .x : .o
    }

    // MARK: Determining Board Outcome

    public enum Outcome {
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
        (0, 4, 8),
        (2, 4, 6)
    ]

    public func evaluateOutcome() -> Outcome? {
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

    // MARK: Displaying The Board
    
    public func printBoard() {
        let displayableBoard = board.map { $0.displayValue }
        print("\(displayableBoard[0]) \(displayableBoard[1]) \(displayableBoard[2])")
        print("\(displayableBoard[3]) \(displayableBoard[4]) \(displayableBoard[5])")
        print("\(displayableBoard[6]) \(displayableBoard[7]) \(displayableBoard[8])")

        print("*************")
    }

    public func boardValue(forIndex index: Int) -> BoardValue {
        return self.board[index]
    }

    // MARK: Hashable

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.board)
    }

    public static func == (lhs: TicTacToeBoard, rhs: TicTacToeBoard) -> Bool {
        return lhs.board == rhs.board
    }
}
