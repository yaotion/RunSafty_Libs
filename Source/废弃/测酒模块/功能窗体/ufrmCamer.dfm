object frmCamera: TfrmCamera
  Left = 0
  Top = 0
  Width = 370
  Height = 293
  TabOrder = 0
  TabStop = True
  object VideoWindow: TVideoWindow
    Left = 0
    Top = 0
    Width = 370
    Height = 293
    Mode = vmVMR
    VMROptions.Mode = vmrWindowed
    VMROptions.Streams = 1
    VMROptions.Preferences = []
    Color = clBlack
    Align = alClient
  end
  object SampleGrabber: TSampleGrabber
    FilterGraph = CaptureGraph
    MediaType.data = {
      7669647300001000800000AA00389B717DEB36E44F52CE119F530020AF0BA770
      FFFFFFFF0000000001000000809F580556C3CE11BF0100AA0055595A00000000
      0000000000000000}
    Left = 176
    Top = 48
  end
  object VideoSource: TFilter
    BaseFilter.data = {00000000}
    FilterGraph = CaptureGraph
    Left = 136
    Top = 48
  end
  object AudioSourceFilter: TFilter
    BaseFilter.data = {00000000}
    FilterGraph = CaptureGraph
    Left = 101
    Top = 44
  end
  object CaptureGraph: TFilterGraph
    Mode = gmCapture
    GraphEdit = True
    LinearVolume = False
    Left = 64
    Top = 48
  end
end
