# frozen_string_literal: true

require_relative '../lib/tile'

class TileDummyClass
  include Tile
end

describe 'Tile' do
  subject(:tile_tester) { TileDummyClass.new }

  describe '#colorize_background' do
    context 'when given color is black' do
      it 'returns the "black" background' do
        actual_output = tile_tester.colorize_background('', 'black')
        expected_output = "\e[48;2;77;40;0m\e[0m"
        expect(actual_output).to eq(expected_output)
      end
    end

    context 'when the given color is white' do
      it 'returns the "white" background' do
        actual_output = tile_tester.colorize_background('', 'white')
        expected_output = "\e[48;2;128;66;0m\e[0m"
        expect(actual_output).to eq(expected_output)
      end
    end

    context 'when text is given' do
      it 'wraps the text in the given background' do
        actual_output = tile_tester.colorize_background('foo', 'white')
        expected_output = "\e[48;2;128;66;0mfoo\e[0m"
        expect(actual_output).to eq(expected_output)
      end
    end
  end

  describe '#colorize_text' do
    context 'when given color is black' do
      it 'returns the "black" wrapping' do
        actual_output = tile_tester.colorize_text('', 'black')
        expected_output = "\e[38;2;0;0;0m\e[0m"
        expect(actual_output).to eq(expected_output)
      end
    end

    context 'when the given color is white' do
      it 'returns the "white" wrapping' do
        actual_output = tile_tester.colorize_text('', 'white')
        expected_output = "\e[38;2;255;243;230m\e[0m"
        expect(actual_output).to eq(expected_output)
      end
    end

    context 'when text is given' do
      it 'sets the text to the given color' do
        actual_output = tile_tester.colorize_text('foo', 'white')
        expected_output = "\e[38;2;255;243;230mfoo\e[0m"
        expect(actual_output).to eq(expected_output)
      end
    end
  end

  describe '#colorize_tile' do
    let(:text) { 'F' }
    let(:text_with_space) { text + ' ' }
    let(:color) { 'white' }
    context 'when a symbol and symbol color are provided' do
      it 'calls #colorize_text with the symbol and symbol color' do
        expect(tile_tester).to receive(:colorize_text).with(text_with_space, color)
        tile_tester.colorize_tile(symbol: text, symbol_color: color, background_color: color)
      end
    end

    context 'when a symbol and symbol color are not provided' do
      it 'does not call #colorize_text' do
        expect(tile_tester).not_to receive(:colorize_text)
        tile_tester.colorize_tile(background_color: color)
      end
    end

    it 'calls #colorize_background with the given background color' do
      expect(tile_tester).to receive(:colorize_background).with('  ', color)
      tile_tester.colorize_tile(background_color: color)
    end
  end
end
