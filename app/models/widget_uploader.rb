require "fog_uploader"

class WidgetUploader
  attr_accessor :fog_uploader
  def initialize(options={})
    self.fog_uploader = options.fetch(:uploader) { FogUploader.new }
  end

  # ...


end

begin
  widget_uploader = WidgetUpload.new(uploader: MyVeryFineUploader.new )
end

class TestThis
  def test_upload
    widgie = WidgetUpload.new(uploader: test_uploader_mock_me)
  end
end
