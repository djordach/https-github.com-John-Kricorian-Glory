//
//  TypeAlias.swift
//  GlorySDK
//
//  Created by John Kricorian on 19/07/2021.
//

import Foundation

typealias GetElementsUseCaseCompletionHandler = (Result<[XMLNode]?, Error>) -> Void

public typealias GetStatusUseCase = (Status) -> Void
public typealias OccupyOperationUseCase = ((OccupyStatus) -> Void)?
public typealias ExitCoverOperationUseCase = ((ExitCoverStatus) -> Void)?
public typealias OpenCoverOperationUseCase = ((OccupyStatus) -> Void)?
public typealias ChangeOperationUseCase = (Transaction) -> Void
public typealias OpenOperationUseCase = (String) -> Void
public typealias ChangeCancelOperationUseCase = ((OccupyStatus) -> Void)?
public typealias RegisterEventOperationUseCase = ((StatusResponse) -> Void)?
public typealias UnRegisterEventOperationUseCase = ((UnRegisterEventStatus) -> Void)?
public typealias InventoryOperationUseCase = ([MoneyItem]) -> Void
public typealias DepositCountChangeUseCase = (Int) -> Void
public typealias AdjustTimeStatusUseCase = (AdjustTimeStatus) -> Void



