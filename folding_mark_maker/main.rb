require 'sketchup.rb'

module SamSPaperModellingExtensions
  module FoldingMarkMaker

def self.make_folding_marks(operation_name, hide_original_edges)
  model = Sketchup.active_model
  if check_selection()
    model.start_operation(operation_name, true)
    self.make_marks(model, hide_original_edges)
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

def self.get_end_points_from_line_segment(edge)
  vertices_on_line = []
  all_edges_on_line = []
  main_vector = edge.line[1]
  main_line = edge.line

  for connected_entity in edge.all_connected
    if connected_entity.is_a?(Sketchup::Edge) && connected_entity.line[1].parallel?(main_vector) && connected_entity.line[0].on_line?(main_line)
      vertices = [connected_entity.start, connected_entity.end]
      for vertex in vertices
        if (not vertices_on_line.include?(vertex))
          vertices_on_line.push(vertex)
        else
          vertices_on_line -= [vertex]
        end
      end
      all_edges_on_line.push(connected_entity)
    end
  end

  if vertices_on_line.length() != 2
    result = UI.messagebox("There was a problem with identifying two vertices of the line given by the edge #{edge.to_s}", MB_OK)
    return false if result = IDOK
  else
    return vertices_on_line, all_edges_on_line
  end
end

def self.draw_mark_line(line_endpoint_1, line_endpoint_2, mark_length, marks_group)
  mark_start_point = line_endpoint_1
  mark_vector = line_endpoint_2.vector_to(mark_start_point).normalize
  mark_vector.length = mark_length
  mark_end_point = mark_start_point + mark_vector
  marks_group.entities.add_line mark_start_point, mark_end_point
end

def self.make_marks(model, hide_original_edges)
  mark_length = 10.cm
  marks_group = model.active_entities.add_group

  edges_already_processed = []
  selected_edges = model.selection.grep(Sketchup::Edge)
  for edge in selected_edges
    if edges_already_processed.include?(edge)
      next
    end

    end_points, edges_on_line = self.get_end_points_from_line_segment(edge)
    edges_already_processed += edges_on_line

    if hide_original_edges
      for edge_on_line in edges_on_line
        edge_on_line.hidden = true
      end
    end
    
    self.draw_mark_line(end_points[0].position, end_points[1].position, mark_length, marks_group)
    self.draw_mark_line(end_points[1].position, end_points[0].position, mark_length, marks_group)
  end
end

unless file_loaded?(__FILE__)
  menu = UI.menu('Plugins')
  menu.add_item('Add Folding Marks') {
    self.make_folding_marks('Make Folding Marks', false)
  }
  menu.add_item('Add Folding Marks && Hide Lines') {
    self.make_folding_marks('Make Folding Marks && Hide Lines', true)
  }
  file_loaded(__FILE__)
end

  end
end
