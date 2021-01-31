# frozen_string_literal: true

require_relative '../lib/move_validation'

describe 'MoveValidation' do
  class MoveValidationDummyClass
    include MoveValidation
  end

  subject(:move_validator) { MoveValidationDummyClass.new }
end