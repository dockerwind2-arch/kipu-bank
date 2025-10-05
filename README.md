# KipuBank

Contrato inteligente en Solidity que permite a los usuarios **depositar y retirar ETH** con límites definidos.

## 📖 Descripción

* Cada usuario tiene una **bóveda personal** donde puede depositar ETH.
* Existe un **límite por retiro** (`withdrawLimit`) definido al desplegar (inmutable).
* Existe un **cap global de depósitos** (`bankCap`) definido al desplegar (inmutable).
* Se emiten eventos en cada depósito y retiro.
* Uso de **errores personalizados** y patrón **checks-effects-interactions**.

## 📁 Estructura del repo

```
kipu-bank/
├─ contracts/
│  └─ KipuBank.sol
├─ README.md
└─ .gitignore
```

## ⚙️ Cómo desplegar (Remix)

1. Abrir [Remix](https://remix.ethereum.org/).

2. Cargar `KipuBank.sol` en el editor.

3. Compilar con versión `>=0.8.2 <0.9.0`.

4. Conectar MetaMask a la testnet elegida (ejemplo: **Sepolia**).

5. En **Deploy**, pasar los parámetros del constructor:

   * `_withdrawLimit` (ejemplo: `100000000000000000` → 0.1 ETH)
   * `_bankCap` (ejemplo: `10000000000000000000` → 10 ETH)

6. Hacer deploy y copiar la dirección del contrato.

7. (Opcional) Verificar el contrato en el explorador de la testnet.

## 📡 Interacciones principales

* **deposit()** — `external payable` → enviar ETH al contrato.
* **withdraw(uint256 amount)** — `external` → retira hasta `withdrawLimit`.
* **getVaultBalance(address user)** — `external view returns (uint256)` → consultar balance del usuario.

## 🔒 Seguridad

El contrato aplica buenas prácticas de seguridad:

* Uso de **errores personalizados** en lugar de strings.
* Aplicación del patrón **checks-effects-interactions** en depósitos y retiros.
* Transferencias de ETH manejadas con una función interna `_safeTransfer`.
* Variables inmutables (`withdrawLimit` y `bankCap`) para mayor confiabilidad.

## 📍 Dirección del contrato desplegado

* **Testnet**: Sepolia
* **Dirección**: `0xa32d7cd8d3d5a626440273bd01ee08c166d5d633`
* **Código verificado en**: [Etherscan](https://sepolia.etherscan.io/address/0xa32d7cd8d3d5a626440273bd01ee08c166d5d633)

## ✅ Entrega

Este repositorio contiene todo lo solicitado en el Trabajo Práctico:

* Contrato inteligente **KipuBank** en Solidity
* Despliegue en testnet Sepolia con código verificado
* Documentación completa en este README
