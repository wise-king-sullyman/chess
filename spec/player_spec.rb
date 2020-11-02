# frozen_string_literal: true

require './lib/player.rb'

describe Player do
  let(:game) { instance_double('game') }
  subject(:player) { Player.new('player 1', 'white', game) }
  let(:piece) { instance_double('piece') }
  let(:board) { instance_double('board') }
  let(:location) { [] }

  before do
    allow($stdout).to receive(:write)
  end

  describe '#move' do
    context 'when a legal, available, and reachable move is given' do
      before do
        allow(piece).to receive(:legal_move?).and_return(true)
        allow(game).to receive(:available?).and_return(true)
        allow(game).to receive(:reachable?).and_return(true)
      end

      it 'calls game.move_piece' do
        player.move
        expect(game).to receive(:move_piece)
      end
    end

    context 'when a legal, available, but unreachable move is given' do
      before do
        allow(piece).to receive(:legal_move?).and_return(true)
        allow(game).to receive(:available?).and_return(true)
        allow(game).to receive(:reachable?).and_return(false, true)
      end

      it 'calls #valid? until a valid move is given' do
        expect(player).to receive(:valid?).twice
      end
    end

    context 'when a legal, reachable, but unavailable move is given' do
      before do
        allow(piece).to receive(:legal_move?).and_return(true)
        allow(game).to receive(:available?).and_return(false, true)
        allow(game).to receive(:reachable?).and_return(true)
      end

      it 'calls #valid? until a valid move is given' do
        expect(player).to receive(:valid?).twice
      end
    end

    context 'when a reachable, available, but non legal move is given' do
      before do
        allow(piece).to receive(:legal_move?).and_return(nil, true)
        allow(game).to receive(:available?).and_return(true)
        allow(game).to receive(:reachable?).and_return(true)
      end

      it 'calls #valid? until a valid move is given' do
        expect(player).to receive(:valid?).twice
      end
    end
  end
end
