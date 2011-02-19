class Comment < Post
  belongs_to :responsible , :class_name =>  "User"
end
