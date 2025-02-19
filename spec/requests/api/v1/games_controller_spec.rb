# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe Api::V1::GamesController, type: :request do
  let(:json) { response.parsed_body }

  describe 'POST #create' do
    it 'creates a new game' do
      expect { post api_v1_games_url }.to change(Game, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end
  end

  describe 'POST #roll' do
    let(:game) { Game.create! }

    context 'with valid params' do
      it 'records a roll and updates the game state' do
        expect do
          post roll_api_v1_game_url(game), params: { pins: '5' }
        end.to change(Roll, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')

        game.reload
        expect(game.current_frame.rolls.last.pins).to eq(5)
      end
    end

    context 'with invalid params' do
      it 'returns an error response for invalid pins' do
        post roll_api_v1_game_url(game), params: { pins: '12' }
        expect(response).to have_http_status(:bad_request)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'returns an error response for a non-existent game' do
        post roll_api_v1_game_url('BREAK_THIS'), params: { pins: '5' }
        expect(response).to have_http_status(:not_found)
      end

      it 'returns an error response for a game that is over' do
        game.update!(completed: true)
        post roll_api_v1_game_url(game), params: { pins: '5' }
        expect(response).to have_http_status(:bad_request)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(json['errors']['game']).to include('game over man! game over!!')
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
