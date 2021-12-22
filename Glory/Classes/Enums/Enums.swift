//
//  Enums.swift
//  GloryFramework
//
//  Created by John Kricorian on 30/07/2021.
//

import Foundation

internal enum Operation: String {
    case adjustTime
    case status
    case open
    case occupy
    case release
    case close
    case change
    case changeCancel
    case inventory
    case registerEvent
    case unregisterEvent
    case reset
    case openCoverExit
    case closeCoverExit
}

internal extension Operation {
    var name: String {
        switch self {
        case .adjustTime:
            return "AdjustTimeOperation"
        case .status:
            return "GetStatus"
        case .open:
            return "OpenOperation"
        case .occupy:
            return "OccupyOperation"
        case .release:
            return "ReleaseOperation"
        case .close:
            return "CloseOperation"
        case .change:
            return "ChangeOperation"
        case .changeCancel:
            return "ChangeCancelOperation"
        case .inventory:
            return "InventoryOperation"
        case .registerEvent:
            return "RegisterEventOperation"
        case .unregisterEvent:
            return "UnRegisterEventOperation"
        case .reset:
            return "ResetOperation"
        case .openCoverExit:
            return "OpenExitCoverOperation"
        case .closeCoverExit:
            return "CloseExitCoverOperation"
        }
    }
}

public enum Tag: String {
    case adjustTime = "AdjustTimeResponse"
    case status = "Status"
    case open = "n:OpenResponse"
    case occupy = "n:OccupyResponse"
    case release = "n:ReleaseResponse"
    case change = "n:ChangeResponse"
    case close = "n:CloseResponse"
    case changeCancel = "ChangeCancelResponse"
    case inventory = "n:InventoryResponse"
    case registerEvent = "n:RegisterEventResponse"
    case unregisterEvent = "n:UnRegisterEventResponse"
    case reset = "n:ResetResponse"
    case openCoverExit = "OpenExitCoverResponse"
    case closeCoverExit = "CloseExitCoverResponse"
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .adjustTime:
            return "AdjustTimeResponse"
        case .status:
            return "Status"
        case .open:
            return "n:OpenResponse"
        case .occupy:
            return "n:OccupyResponse"
        case .release:
            return "n:ReleaseResponse"
        case .change:
            return "n:ChangeResponse"
        case .close:
            return "n:CloseResponse"
        case .changeCancel:
            return "ChangeCancelResponse"
        case .inventory:
            return "n:InventoryResponse"
        case .registerEvent:
            return "n:RegisterEventResponse"
        case .unregisterEvent:
            return "n:UnRegisterEventResponse"
        case .reset:
            return "n:ResetResponse"
        case .openCoverExit:
            return "n:ResetResponse"
        case .closeCoverExit:
            return "n:ResetResponse"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "AdjustTimeResponse":
            self = .adjustTime
        case "Status":
            self = .status
        case "n:OpenResponse":
            self = .open
        case "n:OccupyResponse":
            self = .occupy
        case "n:ReleaseResponse":
            self = .release
        case "n:ChangeResponse":
            self = .change
        case "n:CloseResponse":
            self = .close
        case "n:ChangeCancelResponse":
            self = .change
        case "n:InventoryResponse":
            self = .inventory
        case "n:RegisterEventResponse":
            self = .registerEvent
        case "n:UnRegisterEventResponse":
            self = .unregisterEvent
        case "n:ResetResponse":
            self = .reset
        default:
            return nil
        }
    }
}

@objc public enum DeviceStatus: Int, RawRepresentable {
    case state_initialize
    case state_idle
    case state_idle_occupy
    case state_deposit_busy
    case state_deposit_counting
    case state_deposit_end
    case state_wait_store
    case state_store_busy
    case state_store_end
    case state_wait_return
    case state_count_busy
    case state_count_counting
    case state_replenish_busy
    case state_dispense_busy
    case state_wait_dispense
    case state_refill
    case state_refill_counting
    case state_refill_end
    case state_reset
    case state_collect_busy
    case state_verify_busy
    case state_verifycollect_busy
    case state_inventory_clear
    case state_inventory_adjust
    case state_download_busy
    case state_log_read_busy
    case state_busy
    case state_error
    case state_com_error
    case state_wait_for_reset
    case state_config_error
    case state_locked_by_other_session
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .state_initialize:
            return "state_initialize"
        case .state_idle:
            return "state_idle"
        case .state_idle_occupy:
            return "state_idle_occupy"
        case .state_deposit_busy:
            return "state_deposit_busy"
        case .state_deposit_counting:
            return "state_deposit_counting"
        case .state_deposit_end:
            return "state_deposit_end"
        case .state_wait_store:
            return "state_wait_store"
        case .state_store_busy:
            return "state_store_busy"
        case .state_store_end:
            return "state_store_end"
        case .state_wait_return:
            return "state_wait_return"
        case .state_count_busy:
            return "state_count_busy"
        case .state_count_counting:
            return "state_count_counting"
        case .state_replenish_busy:
            return "state_replenish_busy"
        case .state_dispense_busy:
            return "state_dispense_busy"
        case .state_wait_dispense:
            return "state_wait_dispense"
        case .state_refill:
            return "state_refill"
        case .state_refill_counting:
            return "state_refill_counting"
        case .state_refill_end:
            return "state_refill_end"
        case .state_reset:
            return "state_reset"
        case .state_collect_busy:
            return "state_collect_busy"
        case .state_verify_busy:
            return "state_verify_busy"
        case .state_verifycollect_busy:
            return "state_verifycollect_busy"
        case .state_inventory_clear:
            return "state_inventory_clear"
        case .state_inventory_adjust:
            return "state_inventory_adjust"
        case .state_download_busy:
            return "state_download_busy"
        case .state_log_read_busy:
            return "state_log_read_busy"
        case .state_busy:
            return "state_busy"
        case .state_error:
            return "state_error"
        case .state_com_error:
            return "state_com_error"
        case .state_wait_for_reset:
            return "state_wait_for_reset"
        case .state_config_error:
            return "state_config_error"
        case .state_locked_by_other_session:
            return "state_locked_by_other_session"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "0":
            self = .state_initialize
        case "1000":
            self = .state_idle
        case "1500":
            self = .state_idle_occupy
        case "2000":
            self = .state_deposit_busy
        case "2050":
            self = .state_deposit_counting
        case "2055":
            self = .state_deposit_end
        case "2100":
            self = .state_wait_store
        case "2200":
            self = .state_store_busy
        case "2300":
            self = .state_store_end
        case "2500":
            self = .state_wait_return
        case "2600":
            self = .state_count_busy
        case "2610":
            self = .state_count_counting
        case "2700":
            self = .state_replenish_busy
        case "3000":
            self = .state_dispense_busy
        case "3100":
            self = .state_wait_dispense
        case "4000":
            self = .state_refill
        case "4050":
            self = .state_refill_counting
        case "4055":
            self = .state_refill_end
        case "5000":
            self = .state_reset
        case "6000":
            self = .state_collect_busy
        case "6500":
            self = .state_verify_busy
        case "6600":
            self = .state_verifycollect_busy
        case "7000":
            self = .state_inventory_clear
        case "7100":
            self = .state_inventory_adjust
        case "8000":
            self = .state_download_busy
        case "8100":
            self = .state_log_read_busy
        case "9100":
            self = .state_busy
        case "9200":
            self = .state_error
        case "9300":
            self = .state_com_error
        case "9400":
            self = .state_wait_for_reset
        case "9500":
            self = .state_config_error
        case "50000":
            self = .state_locked_by_other_session
        default:
            return nil
        }
    }
}

public extension Tag {
    var name: String {
        switch self {
        case .adjustTime:
            return "n:AdjustTimeResponse"
        case .status:
            return "Status"
        case .open:
            return "n:OpenResponse"
        case .occupy:
            return "n:OccupyResponse"
        case .release:
            return "n:ReleaseResponse"
        case .change:
            return "n:ChangeResponse"
        case .close:
            return "n:CloseResponse"
        case .changeCancel:
            return "n:ChangeCancelResponse"
        case .inventory:
            return "n:InventoryResponse"
        case .registerEvent:
            return "n:RegisterEventResponse"
        case .unregisterEvent:
            return "n:UnRegisterEventResponse"
        case .reset:
            return "n:ResetResponse"
        case .openCoverExit:
            return "n:OpenExitCoverResponse"
        case .closeCoverExit:
            return "n:CloseExitCoverResponse"
        }
    }
}

public enum RequestParameter: String {
    case adjustTime
    case status
    case open
    case occupy
    case change
    case release
    case close
    case cancel
    case inventory
    case registerEvent
    case unregisterEvent
    case reset
    case openCoverExit
    case closeCoverExit
}

public extension RequestParameter {
    var result: String {
        switch self {
        case .adjustTime:
            return "AdjustTimeRequest"
        case .status:
            return "StatusRequest"
        case .open:
            return "OpenRequest"
        case .occupy:
            return "OccupyRequest"
        case .change:
            return "ChangeRequest"
        case .release:
            return "ReleaseRequest"
        case .close:
            return "CloseRequest"
        case .cancel:
            return "ChangeCancelRequest"
        case .inventory:
            return "InventoryRequest"
        case .registerEvent:
            return "RegisterEventRequest"
        case .unregisterEvent:
            return "UnRegisterEventRequest"
        case .reset:
            return "ResetRequest"
        case .openCoverExit:
            return "OpenExitCoverRequest"
        case .closeCoverExit:
            return "CloseExitCoverRequest"
        }
    }
}

public enum StatusCode: String {
    case unknown
    case notConnected
    case initializing
    case idle
    case atStartingChange
    case waitingInsertionOfCashByChange
    case counting
    case dispensing
    case waitingRemovalOfCashInReject
    case waitingRemovalOfCashOut
    case resetting
    case cancelingOfChangeOperation
    case calculatingChangeAmount
    case cancelingDeposit
    case collecting
    case error
    case uploadFirmware
    case readingLog
    case waitingReplenishment
    case countingReplenishment
    case unlocking
    case waitingInventory
    case fixedDepositAmount
    case fixedDispenseAmount
    case waitingCancellation
    case countedCategory2
    case waitingDepositEnd
    case waitingRemovalOfCOFT
    case sealing
    case autoRecovery
    case programBusy
    case waiting
    case inoperative_Cash_Recycler
    case status_internal_error
    case status_idle
    case status_counting
    case status_using_own
    case status_busy
    case status_error
    case status_error_communication
    case status_dll_initialize_busy
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .notConnected:
            return "not connected"
        case .initializing:
            return "initializing"
        case .idle:
            return "idle"
        case .atStartingChange:
            return "at starting change"
        case .waitingInsertionOfCashByChange:
            return "waiting insertion of cash by change"
        case .counting:
            return "counting"
        case .dispensing:
            return "dispensing"
        case .waitingRemovalOfCashInReject:
            return "waiting removal of cash in reject"
        case .waitingRemovalOfCashOut:
            return "waiting removal of cash out"
        case .resetting:
            return "resetting"
        case .cancelingOfChangeOperation:
            return "canceling of change operation"
        case .calculatingChangeAmount:
            return "calculating change amount"
        case .cancelingDeposit:
            return "canceling deposit"
        case .collecting:
            return "collecting"
        case .error:
            return "error"
        case .uploadFirmware:
            return "upload firmware"
        case .readingLog:
            return "reading log"
        case .waitingReplenishment:
            return "waiting replenishment"
        case .countingReplenishment:
            return "counting replenishment"
        case .unlocking:
            return "unlocking"
        case .waitingInventory:
            return "waiting inventory"
        case .fixedDepositAmount:
            return "fixed deposit amount"
        case .fixedDispenseAmount:
            return "fixed dispense amount"
        case .waitingCancellation:
            return "waiting cancellation"
        case .countedCategory2:
            return "counted category 2"
        case .waitingDepositEnd:
            return "waiting deposit end"
        case .waitingRemovalOfCOFT:
            return "waiting removal of COFT"
        case .sealing:
            return "sealing"
        case .autoRecovery:
            return "auto recovery"
        case .programBusy:
            return "program busy"
        case .waiting:
            return "waiting"
        case .unknown:
            return "unknown"
        case .inoperative_Cash_Recycler:
            return "Inoperative Cash Recycler"
        case .status_internal_error:
            return "status_internal_error"
        case .status_idle:
            return "status_idle"
        case .status_counting:
            return "status_counting"
        case .status_using_own:
            return "status_using_own"
        case .status_busy:
            return "status_busy"
        case .status_error:
            return "status_error"
        case .status_error_communication:
            return "status_error_communication"
        case .status_dll_initialize_busy:
            return "status_dll_initialize_busy"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "0":
            self = .initializing
        case "1":
            self = .idle
        case "2":
            self = .atStartingChange
        case "3":
            self = .waitingInsertionOfCashByChange
        case "4":
            self = .counting
        case "5":
            self = .dispensing
        case "6":
            self = .waitingRemovalOfCashInReject
        case "7":
            self = .waitingRemovalOfCashOut
        case "8":
            self = .resetting
        case "9":
            self = .cancelingOfChangeOperation
        case "10":
            self = .calculatingChangeAmount
        case "11":
            self = .cancelingDeposit
        case "12":
            self = .collecting
        case "13":
            self = .error
        case "14":
            self = .uploadFirmware
        case "15":
            self = .readingLog
        case "16":
            self = .waitingReplenishment
        case "17":
            self = .countingReplenishment
        case "18":
            self = .unlocking
        case "19":
            self = .waitingInventory
        case "20":
            self = .fixedDepositAmount
        case "21":
            self = .fixedDispenseAmount
        case "23":
            self = .waitingCancellation
        case "24":
            self = .countedCategory2
        case "25":
            self = .waitingDepositEnd
        case "26":
            self = .waitingRemovalOfCOFT
        case "27":
            self = .sealing
        case "30":
            self = .autoRecovery
        case "40":
            self = .programBusy
        case "41":
            self = .waiting
        case "99":
            self = .unknown
        case "100":
            self = .inoperative_Cash_Recycler
        default:
            return nil
        }
    }
}

public enum AdjustTimeStatus: String  {
    case unknown
    case error
    case success
    case occupiedByOther
    case notOccupied
    case exclusiveError
    case invalidSession
    case sessionTimeout
    case parameterError
    case programInnerError
    case deviceError
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .error:
            return "error"
        case .success:
            return "success"
        case .occupiedByOther:
            return "occupied by other"
        case .notOccupied:
            return "not occupied"
        case .invalidSession:
            return "invalid session"
        case .sessionTimeout:
            return "session timeout"
        case .programInnerError:
            return "program inner error"
        case .exclusiveError:
            return "exclusive error"
        case .parameterError:
            return "parameter error"
        case .deviceError:
            return "device error"
        case .unknown:
            return "unknown"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "0":
            self = .success
        case "3":
            self = .occupiedByOther
        case "5 ":
            self = .notOccupied
        case "11":
            self = .exclusiveError
        case "21":
            self = .invalidSession
        case "22":
            self = .sessionTimeout
        case "98":
            self = .parameterError
        case "99":
            self = .programInnerError
        case "100":
            self = .deviceError
        case "999":
            self = .error
        case "1000":
            self = .unknown
        default:
            return nil
        }
    }
}

@objc public enum OccupyStatus: Int, RawRepresentable  {
    case success
    case occupiedByOther
    case occupationNotAvailable
    case occupiedByItself
    case invalidSession
    case sessionTimeout
    case programInnerError
    case unknown
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .success:
            return "success"
        case .occupiedByOther:
            return "occupied by other"
        case .occupationNotAvailable:
            return "occupation not available"
        case .occupiedByItself:
            return "occupied by itself"
        case .invalidSession:
            return "invalid session"
        case .sessionTimeout:
            return "session timeout"
        case .programInnerError:
            return "program inner error"
        case .unknown:
            return "unknown"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "0":
            self = .success
        case "3":
            self = .occupiedByOther
        case "4":
            self = .occupationNotAvailable
        case "17":
            self = .occupiedByItself
        case "21":
            self = .invalidSession
        case "22":
            self = .sessionTimeout
        case "99":
            self = .programInnerError
        default:
            return nil
        }
    }
}

public enum CashType: String  {
    case cashInInformation
    case cashOutInformation
    case deviceInternalInventory
    case dispensableInventory
    case denominationControl
    case paymentDenomination
    case verificationDenomination
    case cashOutInformationToCOFB
    case mixedStackerToExit
    case ifCollectionCassetteToExit
    case verifyCollectWithIFCollectionCassetteOption
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .cashInInformation:
            return "cash in information"
        case .cashOutInformation:
            return "cash out information"
        case .deviceInternalInventory:
            return "device internal inventory"
        case .dispensableInventory:
            return "dispensable inventory"
        case .denominationControl:
            return "denomination control"
        case .paymentDenomination:
            return "payment denomination"
        case .verificationDenomination:
            return "verification denomination"
        case .cashOutInformationToCOFB:
            return "cashOut information to COFB"
        case .mixedStackerToExit:
            return "mixed stacker to exit"
        case .ifCollectionCassetteToExit:
            return "if collection cassette to exit"
        case .verifyCollectWithIFCollectionCassetteOption:
            return "verify collect with if collection cassette option"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "1":
            self = .cashInInformation
        case "2":
            self = .cashOutInformation
        case "3":
            self = .deviceInternalInventory
        case "4":
            self = .dispensableInventory
        case "5":
            self = .denominationControl
        case "6":
            self = .paymentDenomination
        case "7":
            self = .verificationDenomination
        case "8":
            self = .cashOutInformationToCOFB
        case "9":
            self = .mixedStackerToExit
        case "10":
            self = .ifCollectionCassetteToExit
        case "11":
            self = .verifyCollectWithIFCollectionCassetteOption
        default:
            return nil
        }
    }
}

public enum ResponseResult: String  {
    case success
    case cancel
    case reset
    case occupiedByOther
    case occupiedByItself
    case notOccupied
    case designationDenominationShortage
    case cancelChangeShortage
    case changeShortage
    case exclusiveError
    case dispensedChangeInconsistency
    case autoRecoveryFailure
    case invalidSession
    case sessionTimeout
    case invalidCassetteNumber
    case improperCassette
    case exchangeRateError
    case countedCategory_2_3
    case duplicateTransaction
    case programInnerError
    case deviceError
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .success:
            return "success"
        case .cancel:
            return "cancel"
        case .reset:
            return "reset"
        case .occupiedByOther:
            return "occupied by other"
        case .occupiedByItself:
            return "occupied by itself"
        case .notOccupied:
            return "not occupied"
        case .designationDenominationShortage:
            return "designation denomination shortage"
        case .cancelChangeShortage:
            return "cancel change shortage"
        case .changeShortage:
            return "change shortage"
        case .exclusiveError:
            return "exclusive error"
        case .dispensedChangeInconsistency:
            return "dispensed change inconsistency"
        case .autoRecoveryFailure:
            return "auto recovery failure"
        case .invalidSession:
            return "invalid session"
        case .sessionTimeout:
            return "session timeout"
        case .invalidCassetteNumber:
            return "invalid cassette number"
        case .improperCassette:
            return "improper cassette"
        case .exchangeRateError:
            return "exchange rate error"
        case .countedCategory_2_3:
            return "counted category 2 3"
        case .duplicateTransaction:
            return "duplicate transaction"
        case .programInnerError:
            return "program inner error"
        case .deviceError:
            return "device error"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "0":
            self = .success
        case "1":
            self = .cancel
        case "2":
            self = .reset
        case "3":
            self = .occupiedByOther
        case "5":
            self = .notOccupied
        case "6":
            self = .designationDenominationShortage
        case "9":
            self = .cancelChangeShortage
        case "10":
            self = .changeShortage
        case "11":
            self = .exclusiveError
        case "12":
            self = .dispensedChangeInconsistency
        case "13":
            self = .autoRecoveryFailure
        case "17":
            self = .occupiedByItself
        case "21":
            self = .invalidSession
        case "22":
            self = .sessionTimeout
        case "40":
            self = .invalidCassetteNumber
        case "41":
            self = .improperCassette
        case "43":
            self = .exchangeRateError
        case "44":
            self = .countedCategory_2_3
        case "96":
            self = .duplicateTransaction
        case "99":
            self = .programInnerError
        case "100":
            self = .deviceError
        default:
            return nil
        }
    }
}

public enum StatusResponse: String  {
    case success
    case invalidSession
    case sessionTimeout
    case numberOfRegistrationOver
    case parameterError
    case programInnerError
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .success:
            return "success"
        case .invalidSession:
            return "invalid session"
        case .sessionTimeout:
            return "session timeout"
        case .numberOfRegistrationOver:
            return "number of registration over"
        case .parameterError:
            return "parameter error"
        case .programInnerError:
            return "program inner error"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "0":
            self = .success
        case "21":
            self = .invalidSession
        case "22":
            self = .sessionTimeout
        case "36":
            self = .numberOfRegistrationOver
        case "98":
            self = .parameterError
        case "99":
            self = .programInnerError
        default:
            return nil
        }
    }
}

public enum UnRegisterEventStatus: String  {
    case success
    case invalidSession
    case sessionTimeout
    case parameterError
    case programInnerError
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .success:
            return "success"
        case .invalidSession:
            return "invalid session"
        case .sessionTimeout:
            return "session timeout"
        case .parameterError:
            return "parameter error"
        case .programInnerError:
            return "program inner error"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "0":
            self = .success
        case "21":
            self = .invalidSession
        case "22":
            self = .sessionTimeout
        case "98":
            self = .parameterError
        case "99":
            self = .programInnerError
        default:
            return nil
        }
    }
}

public enum InventoryStatus: String  {
    case empty
    case nearEmpty
    case exist
    case nearFull
    case full
    case restriction
    case missing
    case n_a
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .empty:
            return "empty"
        case .nearEmpty:
            return "near empty"
        case .exist:
            return "exist"
        case .nearFull:
            return "near Full"
        case .full:
            return "full"
        case .restriction:
            return "restriction"
        case .missing:
            return "missing"
        case .n_a:
            return "n_a"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "0":
            self = .empty
        case "1":
            self = .nearFull
        case "2":
            self = .exist
        case "3":
            self = .nearFull
        case "4":
            self = .full
        case "20":
            self = .restriction
        case "21":
            self = .missing
        case "22":
            self = .n_a
        default:
            return nil
        }
    }
}

public enum Destination: String  {
    case tcp
    case server
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .tcp:
            return "0"
        case .server:
            return "1"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "0":
            self = .tcp
        case "1":
            self = .server
        default:
            return nil
        }
    }
}

public enum Event: String {
    case statusChangeEvent
    case statusResponse
    case inventoryResponse
    case glyCashierEvent
    case incompleteTransaction
    
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .statusResponse:
            return "StatusResponse"
        case .inventoryResponse:
            return "InventoryResponse"
        case .glyCashierEvent:
            return "GlyCashierEvent"
        case .statusChangeEvent:
            return "StatusChangeEvent"
        case .incompleteTransaction:
            return "IncompleteTransaction"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "StatusResponse":
            self = .statusResponse
        case "InventoryResponse":
            self = .inventoryResponse
        case "GlyCashierEvent":
            self = .glyCashierEvent
        case "StatusChangeEvent":
            self = .statusChangeEvent
        case "IncompleteTransaction":
            self = .incompleteTransaction
        default:
            return nil
        }
    }
}

public enum GlyCashierEvent: String {
    case eventDepositCountChange
    case eventError
    case eventRequireVerifyDenomination
    case eventOpened
    case eventClosed
    
    public init(rawValue: String) {
        switch rawValue {
        case "eventDepositCountChange":
            self = .eventDepositCountChange
        case "eventError":
            self = .eventError
        case "eventRequireVerifyDenomination":
            self = .eventRequireVerifyDenomination
        case "eventOpened":
            self = .eventOpened
        case "eventClosed":
            self = .eventClosed
        default:
            self = .eventError
        }
    }
}

public enum DoorId: String {
    case unknown
    case collectionDoor
    case maintenanceDoorOrExitCover
    case upperDoor
    case jamDoor
        
    public typealias RawValue = String
    
    public var rawValue: RawValue {
        switch self {
        case .unknown:
            return "unknown"
        case .collectionDoor:
            return "collection door"
        case .maintenanceDoorOrExitCover:
            return "maintenance door(RBW-100) or exit cover(RBW-150, RBW-50)"
        case .upperDoor:
            return "upper door"
        case .jamDoor:
            return "jam door"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "0":
            self = .unknown
        case "1":
            self = .collectionDoor
        case "2":
            self = .maintenanceDoorOrExitCover
        case "3":
            self = .upperDoor
        case "4":
            self = .jamDoor
        default:
            return nil
        }
    }
}

internal enum DevId: String {
    case bill = "1"
    case coin = "2"
    
    init?(rawValue: String) {
        switch rawValue {
        case "1": self = .bill
        case "2": self = .coin
        default:
            return nil
        }
    }
}

public enum ExitCoverStatus: String  {
    case success = "0"
    case occupiedByOther = "3"
    case notOccupied = "5"
    case exclusiveError = "11"
    case invalidSession = "21"
    case sessionTimeout = "22"
    case passwordExpired = "46"
    case programInnerError = "99"
    case deviceError = "100"
    
    public init?(rawValue: String) {
        switch rawValue {
        case "0" : self = .success
        case "3" : self = .occupiedByOther
        case "5" : self = .notOccupied
        case "11" : self = .exclusiveError
        case "21" : self = .success
        case "22" : self = .invalidSession
        case "46" : self = .sessionTimeout
        case "99" : self = .programInnerError
        case "1000" : self = .deviceError
        default:
            return nil
        }
    }
}








