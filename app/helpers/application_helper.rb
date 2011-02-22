module ApplicationHelper
  def include_css(*files)
    content_for :css do 
      stylesheet_link_tag files.map(&:to_s)
    end
  end
  
  def include_script(*files)
    content_for :script do
      javascript_include_tag files.map{|file| file.to_s}
    end    
  end
  
  def back_button(url=nil)
    link_to "Regresar", (url || :back), :id=>"back-button"
  end
end
