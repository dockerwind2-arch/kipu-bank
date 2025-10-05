// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

/// @title KipuBank
/// @notice Contrato que permite a los usuarios depositar y retirar ETH con límites definidos.
/// @dev Sigue buenas prácticas de seguridad y patrones de Solidity.

contract KipuBank {
    /*//////////////////////////////////////////////////////////////
                               VARIABLES
    //////////////////////////////////////////////////////////////*/

    /// @notice Límite fijo de retiro por transacción (en wei).
    /// @dev Se establece en el constructor y no puede modificarse.
    uint256 public immutable withdrawLimit;

    /// @notice Capital global de depósitos que puede recibir el banco.
    /// @dev Se establece en el constructor y no puede modificarse.
    uint256 public immutable bankCap;

    /// @notice Registro del total depositado en el banco.
    uint256 public totalDeposited;

    /// @notice Registro del número de depósitos realizados.
    uint256 public totalDeposits;

    /// @notice Registro del número de retiros realizados.
    uint256 public totalWithdrawals;

    /// @notice Bóvedas personales de cada usuario.
    mapping(address => uint256) private vaults;

    /*//////////////////////////////////////////////////////////////
                                EVENTOS
    //////////////////////////////////////////////////////////////*/

    /// @notice Emitido cuando un usuario deposita ETH exitosamente.
    /// @param user Dirección del usuario que deposita.
    /// @param amount Monto depositado en wei.
    event Deposited(address indexed user, uint256 amount);

    /// @notice Emitido cuando un usuario retira ETH exitosamente.
    /// @param user Dirección del usuario que retira.
    /// @param amount Monto retirado en wei.
    event Withdrawn(address indexed user, uint256 amount);

    /*//////////////////////////////////////////////////////////////
                                 ERRORES
    //////////////////////////////////////////////////////////////*/

    /// @notice Error cuando el depósito excede el límite global del banco.
    error ErrorDepositoExcedeCap();

    /// @notice Error cuando el retiro excede el límite permitido por transacción.
    error ErrorRetiroExcedeLimite();

    /// @notice Error cuando el usuario no tiene fondos suficientes en su bóveda.
    error ErrorFondosInsuficientes();
    
    /// @notice Error cuando la transferencia de ETH falla.
    error ErrorTransferenciaFallida();


    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    /// @param _withdrawLimit Límite máximo de retiro por transacción.
    /// @param _bankCap Capital global de depósitos para el banco.
    constructor(uint256 _withdrawLimit, uint256 _bankCap) {
        withdrawLimit = _withdrawLimit;
        bankCap = _bankCap;
    }

	/// @notice Modificador para validar montos mayores a cero.
    /// @param amount Monto que se desea usar en una transacción.
    modifier validAmount(uint256 amount) {
        require(amount > 0, "Monto debe ser mayor a cero");
        _;
    }
    
    /*//////////////////////////////////////////////////////////////
                                FUNCIONES
    //////////////////////////////////////////////////////////////*/

    /// @notice Permite a un usuario depositar ETH en su bóveda.
    /// @dev Revierte si el depósito supera el límite global.
      function deposit() external payable {
 
        if (totalDeposited + msg.value > bankCap) {
            revert ErrorDepositoExcedeCap();
        }
 
        vaults[msg.sender] += msg.value;
        totalDeposited += msg.value;
        totalDeposits++;

       emit Deposited(msg.sender, msg.value);
    }

    /// @notice Permite a un usuario retirar fondos de su bóveda, respetando el límite por transacción.
    /// @dev Revierte si el retiro excede el limite y si los fondos son insuficientes.
    /// @param amount Monto a retirar en wei.
    function withdraw(uint256 amount) external validAmount(amount) {
        if (amount > withdrawLimit) {
            revert ErrorRetiroExcedeLimite();
        }
        if (vaults[msg.sender] < amount) {
            revert ErrorFondosInsuficientes();
        }

        vaults[msg.sender] -= amount;
        totalDeposited -= amount;
        totalWithdrawals++;
    
        _safeTransfer(msg.sender, amount);
         emit Withdrawn(msg.sender, amount);
    }

    /// @notice Realiza una transferencia segura de ETH.
    /// @dev Se usa internamente para evitar vulnerabilidades.
    function _safeTransfer(address to, uint256 amount) private {
        (bool success, ) = to.call{value: amount}("");
         if (!success) {
        revert ErrorTransferenciaFallida();
         }
    }
    
    
    /// @notice Devuelve el balance de la bóveda de un usuario.
    /// @param user Dirección del usuario.
    /// @return Balance en wei de la bóveda del usuario.
    function getVaultBalance(address user) external view returns (uint256) {
        return vaults[user];
    }
}