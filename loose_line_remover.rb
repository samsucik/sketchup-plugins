require 'sketchup.rb'
require 'extensions.rb'

module SamSPaperModellingExtensions
  module LooseLineRemover

    unless file_loaded?(__FILE__)
      ex = SketchupExtension.new('Loose Line Remover', 'loose_line_remover/main')
      ex.description = 'SketchUp extension removing loose line ends from selected objects.'
      ex.version     = '1.0.0'
      ex.copyright   = 'Sam Sucik © 2022'
      ex.creator     = 'Sam Sucik'
      Sketchup.register_extension(ex, true)
      file_loaded(__FILE__)
    end

  end
end
