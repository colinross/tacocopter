module StoresHelper
  def results_table_row(data)
    content_tag(:tr, class: cycle('even', 'odd')) do
      data.collect {|datum| concat(content_tag(:td, datum)) }
    end
  end
end
