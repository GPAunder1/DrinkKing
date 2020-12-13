# frozen_string_literal: true

folders = %w[presentation application infrastructure]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
