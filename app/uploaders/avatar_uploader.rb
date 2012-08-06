# coding: utf-8
class AvatarUploader < BaseUploader
  version :s do
    process :resize_to_fill => [30, 30]
  end

  version :c do
    process :resize_to_fill => [50, 50]
  end

  version :m do
    process :resize_to_fill => [80, 80]
  end

  version :l do
    process :resize_to_fill => [180, 180]
  end

  def store_dir
    '~/uploaded/avatar'
  end

  def default_url
    "avatar/avatar_#{version_name}.jpg"
  end  

end