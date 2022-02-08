require 'sketchup.rb'

module SamSPaperModellingExtensions
  module LooseLineRemover

def self.remove_loose_line_ends
  model = Sketchup.active_model
  if check_selection()
    model.start_operation('Remove Loose Line Ends', true)
    analyse_and_remove()
    model.commit_operation
  end
end

def self.check_selection
  selected_edges = Sketchup.active_model.selection.grep(Sketchup::Edge)
  if selected_edges.length() == 0
    result = UI.messagebox("You haven't selected any edges. Select some." , MB_OK)
    return false if result = IDOK
  else
    return true
  end
end

def self.analyse_and_remove
  stop = false
  while (not stop)
    edges_to_remove = []
    edges = Sketchup.active_model.selection.grep(Sketchup::Edge)
    for edge in edges
      if edge.faces.length() == 0
        edges_to_remove.push(edge)
      end
    end
    if edges_to_remove.length() > 0
      Sketchup.active_model.active_entities.erase_entities(edges_to_remove)
    else
      stop = true
    end
  end
end

unless file_loaded?(__FILE__)
  menu = UI.menu('Plugins')
  menu.add_item('Remove Loose Line Ends') {
    self.remove_loose_line_ends
  }
  file_loaded(__FILE__)
end

  end
end
