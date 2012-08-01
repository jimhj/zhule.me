class Notification::JoinAssistance < Notification::Base
  belongs_to :assistance
  belongs_to :assistance_helper
end