# frozen_string_literal: true

class Tile
  attr_reader :symbol, :symbol_color, :background_color

  def initialize(symbol: '  ', symbol_color: nil, background_color:)
    @symbol = symbol
    @symbol_color =symbol_color
    @background_color = background_color
  end

  def colorize_background(text, color)
    case color
    when 'black'
      "\e[40m#{text}\e[0m"
    when 'white'
      "\e[100m#{text}\e[0m"
    end
  end

  def colorize_text(text, color)
    case color
    when 'black'
      "\e[30m#{text}\e[0m"
    when 'white'
      "\e[37;1m#{text}\e[0m"
    end
  end

  def to_s
    content = symbol_color ? colorize_text(symbol, symbol_color) : symbol
    colorize_background(content, background_color)
  end
end
