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
    'system/uploaded/avatar'
  end

  def default_url
    "avatar/avatar_#{version_name}.jpg"
  end  

  # Override the filename of the uploaded files:
  def filename
    if super.present?
      # current_path 是 Carrierwave 上传过程临时创建的一个文件，有时间标记，所以它将是唯一的
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension.downcase}"
    end
  end

end