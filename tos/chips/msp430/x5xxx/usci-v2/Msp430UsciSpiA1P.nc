/* DO NOT MODIFY
 * This file cloned from Msp430UsciSpiB0P.nc for A1 */
configuration Msp430UsciSpiA1P {
  provides {
    interface SpiPacket[ uint8_t client ];
    interface SpiBlock;
    interface SpiByte;
    interface FastSpiByte;
    interface Msp430UsciError;
    interface ResourceConfigure[ uint8_t client ];
  }
  uses {
    interface Msp430UsciConfigure[ uint8_t client ];
    interface HplMsp430GeneralIO as SIMO;
    interface HplMsp430GeneralIO as SOMI;
    interface HplMsp430GeneralIO as CLK;
    interface Panic;
    interface Platform;
 }
}
implementation {

  components     Msp430UsciA1P    as UsciC;
  components new Msp430UsciSpiP() as SpiC;

  SpiC.Usci           -> UsciC;
  SpiC.Interrupts     -> UsciC.Interrupts[MSP430_USCI_SPI];
  SpiC.ArbiterInfo    -> UsciC;

  Msp430UsciConfigure = SpiC;
  ResourceConfigure   = SpiC;
  SpiPacket           = SpiC;
  SpiBlock            = SpiC;
  SpiByte             = SpiC;
  FastSpiByte         = SpiC;
  Msp430UsciError     = SpiC;
  Panic               = SpiC;
  Platform            = SpiC;
  SIMO                = SpiC.SIMO;
  SOMI                = SpiC.SOMI;
  CLK                 = SpiC.CLK;
}
