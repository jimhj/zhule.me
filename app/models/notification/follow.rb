class Notification::Follow < Notification::Base
  belongs_to :user_follow
end