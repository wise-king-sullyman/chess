# frozen_string_literal: true

require './lib/player.rb'

describe Player do
  let(:game) { double('game') }
  let(:board) { double('board') }
  subject(:player) { Player.new('player 1', 'white', game, board) }
  let(:piece) { double('piece') }
  let(:pieces) { player.instance_variable_get('@pieces') }
  let(:location) { [] }

  before do
    allow($stdout).to receive(:write)
    allow(board).to receive(:piece_at).and_return(piece)
    allow(piece).to receive(:player).and_return(player)
    allow(player).to receive(:gets).and_return('foo')
    allow(game).to receive(:move_piece)
  end

  describe '#move' do
    context 'when a valid move is given to an owned piece' do
      before do
        allow(player).to receive(:valid?).and_return(true)
        allow(player).to receive(:piece_is_mine?).and_return(true)
      end

      it 'calls #valid? until a valid move is given' do
        expect(player).to receive(:valid?).once
        player.move
      end

      it 'calls game.move_piece' do
        expect(game).to receive(:move_piece)
        player.move
      end
    end

    context 'when a valid move is given to an unowned piece' do
      before do
        allow(player).to receive(:valid?).and_return(true)
        allow(player).to receive(:piece_is_mine?).and_return(false, true)
      end

      it 'calls #piece_is_mine? until a valid move is given' do
        expect(player).to receive(:piece_is_mine?).twice
        player.move
      end

      it 'calls game.move_piece once passing conditions are met' do
        expect(game).to receive(:move_piece).once
        player.move
      end
    end

    context 'when an invalid move is given to an owned piece' do
      before do
        allow(player).to receive(:valid?).and_return(false, true)
        allow(player).to receive(:piece_is_mine?).and_return(true)
      end

      it 'calls #valid? until a valid move is given' do
        expect(player).to receive(:valid?).twice
        player.move
      end

      it 'calls game.move_piece once passing conditions are met' do
        expect(game).to receive(:move_piece).once
        player.move
      end
    end
  end

  describe '#assign_pieces' do
    let(:player2) { Player.new('player 2', 'black', game, board) }
    let(:player2_pieces) { player2.instance_variable_get('@pieces') }

    context 'when player is white' do
      it 'has a size of 16' do
        expect(pieces.size).to eql(16)
      end

      it 'gives the king the right location' do
        expect(pieces[7].location).to eql([7, 4])
      end
    end

    context 'when player is black' do
      it 'has a size of 16' do
        expect(player2_pieces.size).to eql(16)
      end

      it 'gives the king the right location' do
        expect(player2_pieces[7].location).to eql([0, 4])
      end
    end
  end

  describe '#remove_piece' do
    let(:piece) { pieces[7] }
    let(:lost_pieces) { player.instance_variable_get('@lost_pieces') }
    it 'removes the piece from @pieces' do
      player.remove_piece(piece)
      expect(pieces).not_to include(piece)
    end

    it 'adds the piece to @lost_piece' do
      player.remove_piece(piece)
      expect(lost_pieces).to include(piece)
    end
  end
end
