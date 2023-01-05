module Display
    def empty_circle
        "\u25cb "
    end

    def blue_circle
        "\e[34m\u25cf\e[0m "
    end
    
    def yellow_circle
        "\e[33m\u25cf\e[0m "
    end

    def error_message(message, index = nil)
        {
            'Input error': 'Please type in a number from 1 to 7',
            'Out of column space error': "Column #{index} has no space left. Please enter another column"
        }[message]
    end
end

class Player
    attr_accessor :symbol
    def initialize(symbol)
        @symbol = symbol
    end
end

class Game
    attr_accessor :board, :turn, :player1, :player2
    include Display

    def play
        reset_board
        @turn = 0
        @player1 = Player.new(blue_circle)
        @player2 = Player.new(yellow_circle)
        player_turn
    end

    def reset_board
        @board = [[empty_circle, empty_circle, empty_circle, empty_circle, empty_circle, empty_circle, empty_circle,],
                    [empty_circle, empty_circle, empty_circle, empty_circle, empty_circle, empty_circle, empty_circle, ],
                    [empty_circle, empty_circle, empty_circle, empty_circle, empty_circle, empty_circle, empty_circle, ],
                    [empty_circle, empty_circle, empty_circle, empty_circle, empty_circle, empty_circle, empty_circle, ],
                    [empty_circle, empty_circle, empty_circle, empty_circle, empty_circle, empty_circle, empty_circle, ],
                    [empty_circle, empty_circle, empty_circle, empty_circle, empty_circle, empty_circle, empty_circle, ]]
        @board.each do |row|
            row.each do |node|
                print node
            end
            print "\n"
        end
        puts "1 2 3 4 5 6 7\n\n"
    end

    def player_turn
        input = player_input - 1
        if check_available_space(input) 
            update_board(input)
            display_board
            if check_winner 
                new_game_prompt
            else
                @turn += 1
                player_turn
            end
        else
            puts error_message('Out of column space error', input)
            player_turn
        end
    end
     
    def player_input
        print "Enter a column [1-7]: "
        input = gets.chomp
        return input.to_i if input.match(/^[1-7]$/)
        puts error_message('Input error')
        player_input
    end

    def check_available_space(input)
        board[0][input] == empty_circle
    end

    def check_column_space(input)
        i = 5
        while i >= 0 do
            if board[i][input] == empty_circle
                return i
            else
                i -=1
            end
        end
    end

    def check_winner
        if (check_column || check_row || check_diagonal)
            if (turn.even?)
                puts "Player 1 won"
                return true
            else
                puts "Player 2 won"
                return true
            end
        end
        if turn > 42
            puts "It's a draw"
            return true
        end
        return false
    end
    
    def check_row
        for row in 0..5
            for i in 0..3
                return true if (board[row][i] == board[row][i+1] && board[row][i] == board[row][i+2] && board[row][i] == board[row][i+3] && board[row][i] != empty_circle)
            end
        end
        return false
    end

    def check_column
        for column in 0..6
            for i in [5,4,3]
                return true if (board[i][column] == board[i-1][column] && board[i][column] == board[i-2][column] && board[i][column] == board[i-3][column] && board[i][column] != empty_circle)
            end
        end
        return false
    end

    def check_diagonal
        begin
            for i in 0..2
                for j in 0..3
                    return true if (board[i][j] == board[i+1][j+1] && board[i][j] == board[i+2][j+2] && board[i][j] == board[i+3][j+3] && board[i][j] != empty_circle)
                end
            end
            for i in [5,4,3]
                for j in 0..3
                    return true if (board[i][j] == board[i-1][j+1] && board[i][j] == board[i-2][j+2] && board[i][j] == board[i-3][j+3] && board[i][j] != empty_circle)
                end
            end
        rescue IndexError

        end
        return false
    end

    def update_board(input)
        index = check_column_space(input)
        if turn.even?
            board[index][input] = player1.symbol
        else
            board[index][input] = player2.symbol
        end
    end

    def display_board
        board.each do |row|
            row.each do |node|
                print node
            end
            print "\n"
        end
        puts "1 2 3 4 5 6 7\n\n"
    end

    def new_game_prompt
        print "Enter y to play new game: "
        input = gets.chomp
        input.downcase == 'y' ? Game.new.play : puts('Thanks for playing!')
    end
end



Game.new.play