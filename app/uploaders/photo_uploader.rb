# coding: utf-8
class PhotoUploader < BaseUploader

  version :m do
    process :resize_to_limit => [80, nil]
  end

  version :l do
    process :resize_to_limit => [400, nil]
  end

  def store_dir
    '~/uploaded/photo'
  end

end