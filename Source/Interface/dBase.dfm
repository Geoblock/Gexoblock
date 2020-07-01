object dmBase: TdmBase
  OldCreateOrder = False
  Height = 428
  Width = 674
  object FDTable: TFDTable
    Connection = FDConnection
    Left = 40
    Top = 184
  end
  object FDQuery: TFDQuery
    Connection = FDConnection
    Left = 120
    Top = 184
  end
  object FDConnection: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    LoginPrompt = False
    Transaction = FDTransaction
    Left = 144
    Top = 32
  end
  object FDPhysPgDriverLink: TFDPhysPgDriverLink
    VendorLib = 'C:\Program Files (x86)\PostgreSQL\9.5\bin\libpq.dll'
    Left = 40
    Top = 104
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 144
    Top = 104
  end
  object DataSource: TDataSource
    DataSet = FDTable
    Left = 464
    Top = 40
  end
  object SQLQuery: TSQLQuery
    Params = <>
    Left = 432
    Top = 312
  end
  object SQLTable: TSQLTable
    Left = 360
    Top = 312
  end
  object SQLConnection: TSQLConnection
    Left = 512
    Top = 312
  end
  object SQLDataSet: TSQLDataSet
    Params = <>
    Left = 592
    Top = 312
  end
  object FDManager: TFDManager
    ConnectionDefFileName = 'D:\Gexoblock\Data\GXConnections.ini'
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <>
    Active = True
    Left = 32
    Top = 32
  end
  object FDTransaction: TFDTransaction
    Connection = FDConnection
    Left = 248
    Top = 32
  end
  object FDCommand: TFDCommand
    Connection = FDConnection
    Left = 128
    Top = 272
  end
  object FDMemTable: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 192
    Top = 184
  end
  object FDLocalSQL: TFDLocalSQL
    Left = 40
    Top = 360
  end
  object FDTableAdapter: TFDTableAdapter
    Left = 224
    Top = 272
  end
  object FDBatchMove: TFDBatchMove
    Mappings = <>
    LogFileName = 'Data.log'
    Left = 48
    Top = 272
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    MasterSource = DataSource
    PacketRecords = 0
    Params = <>
    Left = 552
    Top = 40
  end
  object FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink
    Left = 264
    Top = 104
  end
end
