class Notification::Assist < Notification::Base
  belongs_to :assistance
  belongs_to :assistance_helper
end