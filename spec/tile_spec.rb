# frozen_string_literal: true

require_relative '../lib/tile'

describe 'Tile' do
  class TileDummyClass
    include Tile
  end

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
end
