// SPDX-License-Identifier: GPL-3.0
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity >=0.7.0 <0.9.0;

/* generatecall
["0x032e11c1b63150815edd69ee93cf2dc9ac9bfd032431c5273d9d37236401e7b6", "0x2464578d9fd8747189ffecbefd31c8f05a9c8a6312525d041e9edc146d2f996f"],
[["0x1d747cbec2b00d111dbe261f9303ca2e56ef40dfe7ceffb24429d3dcb051483a", "0x2f8f8f1a94ecd0853e9e3de405c6ac08de85bf2d84eb60f2b73564daafa3c2f7"],
 ["0x16ed5be69ca7e27598e27614bbe55048790d14b4f794d999b22b0f400d032dfd", "0x27ac2419c3a2206af155aac3e8fe011282d764c24abdffcd16a9a2ebd551333f"]],
["0x0dd3a40ac602a94d01b9adcdeaf102c8897c77436ec1a4270c13e8a24549115b", "0x0ff7837071aa69feea8459a72302fb6207ff745e18b1e7f070b338d8495b5dfb"],
["0x0000000000000000000000000000000000000000000000000000000000000001"]
*/

contract Groth16Verifier {
    // Scalar field size
    uint256 constant r    = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // Base field size
    uint256 constant q   = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

    // Verification Key data
    uint256 constant alphax  = 21227477831102083575821338045657467570160685953364071154087669995385022483416;
    uint256 constant alphay  = 12884281933677896847262705610456522648540720149111164016368779513473636783405;
    uint256 constant betax1  = 6205827723185318737648527230640862215650024497538643984311085982106639996038;
    uint256 constant betax2  = 4337263327231540708458204933506543605978961832272249197216296039904224144411;
    uint256 constant betay1  = 15855157138674264003045548312821927588569974596046334848815627405294950855595;
    uint256 constant betay2  = 11689583290454390908352452482063030811752542672843428450564640252405471849722;
    uint256 constant gammax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant gammax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant gammay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant gammay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 constant deltax1 = 5758206963089419414475822480119061345362845125899737259833042144839415925015;
    uint256 constant deltax2 = 3342255888346523612812616277168429366742500257126622628524462402279543943780;
    uint256 constant deltay1 = 14519043745709290938842444185045012368932638158235243416315148210589016834904;
    uint256 constant deltay2 = 13682469797748833618338724079001651262699042037602685597168891105671259079752;

    
    uint256 constant IC0x = 18909306720752793267161661874604273389977925615355884154387233542333124840841;
    uint256 constant IC0y = 9904949823377515640944712805725071631679988502728651588491202236252145792056;
    
    uint256 constant IC1x = 4770344137192749179533718990761565393535553812404781824117622724216349044152;
    uint256 constant IC1y = 4762006505948011553831097387346225544119119750339248599816818238532239132397;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[1] calldata _pubSignals) public view returns (bool) {
        assembly {
            function checkField(v) {
                if iszero(lt(v, q)) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }
            
            // G1 function to multiply a G1 value(x,y) to value in an address
            function g1_mulAccC(pR, x, y, s) {
                let success
                let mIn := mload(0x40)
                mstore(mIn, x)
                mstore(add(mIn, 32), y)
                mstore(add(mIn, 64), s)

                success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }

                mstore(add(mIn, 64), mload(pR))
                mstore(add(mIn, 96), mload(add(pR, 32)))

                success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function checkPairing(pA, pB, pC, pubSignals, pMem) -> isOk {
                let _pPairing := add(pMem, pPairing)
                let _pVk := add(pMem, pVk)

                mstore(_pVk, IC0x)
                mstore(add(_pVk, 32), IC0y)

                // Compute the linear combination vk_x
                
                g1_mulAccC(_pVk, IC1x, IC1y, calldataload(add(pubSignals, 0)))
                

                // -A
                mstore(_pPairing, calldataload(pA))
                mstore(add(_pPairing, 32), mod(sub(q, calldataload(add(pA, 32))), q))

                // B
                mstore(add(_pPairing, 64), calldataload(pB))
                mstore(add(_pPairing, 96), calldataload(add(pB, 32)))
                mstore(add(_pPairing, 128), calldataload(add(pB, 64)))
                mstore(add(_pPairing, 160), calldataload(add(pB, 96)))

                // alpha1
                mstore(add(_pPairing, 192), alphax)
                mstore(add(_pPairing, 224), alphay)

                // beta2
                mstore(add(_pPairing, 256), betax1)
                mstore(add(_pPairing, 288), betax2)
                mstore(add(_pPairing, 320), betay1)
                mstore(add(_pPairing, 352), betay2)

                // vk_x
                mstore(add(_pPairing, 384), mload(add(pMem, pVk)))
                mstore(add(_pPairing, 416), mload(add(pMem, add(pVk, 32))))


                // gamma2
                mstore(add(_pPairing, 448), gammax1)
                mstore(add(_pPairing, 480), gammax2)
                mstore(add(_pPairing, 512), gammay1)
                mstore(add(_pPairing, 544), gammay2)

                // C
                mstore(add(_pPairing, 576), calldataload(pC))
                mstore(add(_pPairing, 608), calldataload(add(pC, 32)))

                // delta2
                mstore(add(_pPairing, 640), deltax1)
                mstore(add(_pPairing, 672), deltax2)
                mstore(add(_pPairing, 704), deltay1)
                mstore(add(_pPairing, 736), deltay2)


                let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)

                isOk := and(success, mload(_pPairing))
            }

            let pMem := mload(0x40)
            mstore(0x40, add(pMem, pLastMem))

            // Validate that all evaluations ∈ F
            
            checkField(calldataload(add(_pubSignals, 0)))
            
            checkField(calldataload(add(_pubSignals, 32)))
            

            // Validate all evaluations
            let isValid := checkPairing(_pA, _pB, _pC, _pubSignals, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }
