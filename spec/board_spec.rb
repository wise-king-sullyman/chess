# frozen_string_literal: true

require './lib/board.rb'
require './lib/piece.rb'

describe Board do
  subject(:board) { Board.new }

  describe '#to_s' do
    before do
      allow($stdout).to receive(:write)
    end

    context 'when board is blank' do
      it 'prints a blank board' do
        output_string =
          "□ □ □ □ □ □ □ □ \n□ □ □ □ □ □ □ □ \n□ □ □ □ □ □ □ □ \n"\
          "□ □ □ □ □ □ □ □ \n□ □ □ □ □ □ □ □ \n□ □ □ □ □ □ □ □ \n"\
          "□ □ □ □ □ □ □ □ \n□ □ □ □ □ □ □ □ \n"
        expect do
          puts board
        end.to output(output_string).to_stdout
      end
    end

    context 'after a piece is added' do
      let(:player) { instance_double('player') }
      let(:game) { instance_double('game')}
      let(:piece) { Pawn.new(game, player, [1, 0]) }
      it 'prints the piece in place' do
        allow(player).to receive(:color).and_return('white')
        board.update(1, 0, piece)
        output_string =
          "□ □ □ □ □ □ □ □ \n♙ □ □ □ □ □ □ □ \n□ □ □ □ □ □ □ □ \n"\
          "□ □ □ □ □ □ □ □ \n□ □ □ □ □ □ □ □ \n□ □ □ □ □ □ □ □ \n"\
          "□ □ □ □ □ □ □ □ \n□ □ □ □ □ □ □ □ \n"
        expect do
          puts board
        end.to output(output_string).to_stdout
      end
    end
  end

  describe '#update' do
    it 'adds a piece to the board when requested' do
      board.update(1, 0, 1)
      expect(board.instance_variable_get('@game_board')[1][0]).to eql(1)
    end
  end

  describe '#piece_at' do
    let(:piece) { instance_double('piece') }
    context 'when a piece is present' do
      it 'returns the piece' do
        board.update(0, 4, piece)
        expect(board.piece_at([0, 4])).to eql(piece)
      end
    end
  end
end
