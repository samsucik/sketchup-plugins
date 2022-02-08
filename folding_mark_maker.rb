require 'sketchup.rb'
require 'extensions.rb'

module SamSPaperModellingExtensions
  module FoldingMarkMaker

    unless file_loaded?(__FILE__)
      ex = SketchupExtension.new('Folding Mark Maker', 'folding_mark_maker/main')
      ex.description = 'SketchUp extension removing loose line ends from selected objects.'
      ex.version     = '1.0.0'
      ex.copyright   = 'Sam Sucik © 2022'
      ex.creator     = 'Sam Sucik'
      Sketchup.register_extension(ex, true)
      file_loaded(__FILE__)
    end

  end
end
