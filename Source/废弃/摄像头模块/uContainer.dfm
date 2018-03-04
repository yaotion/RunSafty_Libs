object Container: TContainer
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 274
  Width = 371
  object SampleGrabber: TSampleGrabber
    OnBuffer = SampleGrabberBuffer
    FilterGraph = CaptureGraph
    MediaType.data = {
      7669647300001000800000AA00389B717DEB36E44F52CE119F530020AF0BA770
      FFFFFFFF0000000001000000809F580556C3CE11BF0100AA0055595A00000000
      0000000000000000}
    Left = 200
    Top = 48
  end
  object VideoSource: TFilter
    BaseFilter.data = {00000000}
    FilterGraph = CaptureGraph
    Left = 136
    Top = 48
  end
  object CaptureGraph: TFilterGraph
    Mode = gmCapture
    GraphEdit = True
    LinearVolume = False
    Left = 64
    Top = 48
  end
end
