object Form1: TForm1
  Left = 224
  Top = 126
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'GET Math'
  ClientHeight = 329
  ClientWidth = 554
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 10
    Top = 265
    Width = 138
    Height = 16
    Caption = 'http://coffee-cup.3dn.ru/'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = Label1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 297
    Height = 249
    Lines.Strings = (
      #1055#1088#1080#1084#1077#1088' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1087#1088#1086#1089#1095#1077#1090#1072' '
      #1084#1072#1090#1077#1084#1072#1090#1080#1095#1077#1089#1082#1080#1093' 2+24 '
      #1074#1099#1088#1072#1078#1077#1085#1080#1081' '#1080#1079' '#1090#1077#1082#1089#1090#1072
      #1055#1080#1096#1077#1084' '#1074#1099#1088#1072#1078#1077#1085#1080#1077' 22+321+3'
      #1080' '#1087#1088#1086#1075#1088#1072#1084#1084#1072' '#1089#1095#1080#1090#1072#1077#1090' 34+34-223+44443'
      ''
      '2+2'
      '2+2+1'
      '2+2-1'
      ''
      'BlackCash 2*2*2*2*2+1')
    TabOrder = 0
  end
  object ListBox1: TListBox
    Left = 312
    Top = 8
    Width = 233
    Height = 249
    ItemHeight = 16
    TabOrder = 1
  end
  object Button1: TButton
    Left = 10
    Top = 295
    Width = 535
    Height = 26
    Caption = 'Calculate'
    TabOrder = 2
    OnClick = Button1Click
  end
end
