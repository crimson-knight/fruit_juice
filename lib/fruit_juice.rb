# frozen_string_literal: true

require "redis"

require_relative "fruit_juice/version"
require_relative "fruit_juice/delayed_job"

module FruitJuice
  class Error < StandardError; end
end
