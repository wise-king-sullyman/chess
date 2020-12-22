# frozen_string_literal: true

# Used to colorize the tiles in the game board
module Tile
  def colorize_background(text, color)
    case color
    when 'black'
      "\e[48;2;77;40;0m#{text}\e[0m"
    when 'white'
      "\e[48;2;128;66;0m#{text}\e[0m"
    end
  end

  def colorize_text(text, color)
    case color
    when 'black'
      "\e[38;2;0;0;0m#{text}\e[0m"
    when 'white'
      "\e[38;2;255;243;230m#{text}\e[0m"
    end
  end

  def colorize_tile(symbol: ' ', symbol_color: nil, background_color:)
    symbol += ' '
    content = symbol_color ? colorize_text(symbol, symbol_color) : symbol
    colorize_background(content, background_color)
  end
end
