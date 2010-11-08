module ApplicationHelper
  def include_css(file="")
    content_for :css do 
      stylesheet_link_tag file
    end
  end
  
  def include_script(file="")
    content_for :script do
      javascript_include_tag file
    end    
  end
end
