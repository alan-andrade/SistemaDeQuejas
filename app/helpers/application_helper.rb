module ApplicationHelper
  def include_css(file="")
    content_for :css do 
      stylesheet_link_tag file
    end
  end
end
