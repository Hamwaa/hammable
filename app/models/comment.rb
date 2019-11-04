class Comment < ApplicationRecord
  belongs_to :ham
  belongs_to :user
end

