/*
 * Copyright (c) 2008-2012, SOWNet Technologies B.V.
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
*/

#include "PacketTimeSync.h"

configuration ChipconTimeSyncMessageC {
	provides {
		interface StdControl;
		interface SplitControl;
		interface Receive[am_id_t id];
		interface Receive as Snoop[am_id_t id];
		interface AMPacket;
		interface Packet;
		interface LowPowerListening;
		interface PacketAcknowledgements;

		interface TimeSyncAMSend<TMilli, uint32_t> as TimeSyncAMSendMilli[am_id_t];
		interface TimeSyncPacket<TMilli, uint32_t> as TimeSyncPacketMilli;
		interface PacketTimeStamp<TMilli, uint32_t>  as PacketTimeStampMilli;
		
		interface TimeSyncAMSend<T32khz, uint32_t> as TimeSyncAMSend32khz[am_id_t] ;
		interface TimeSyncPacket<T32khz, uint32_t> as TimeSyncPacket32khz;
		interface PacketTimeStamp<T32khz, uint32_t> as PacketTimeStamp32khz;
	}
}

implementation {
	
	components PacketTimeSyncC, PacketTimeStampC, ActiveMessageC;
	
	StdControl = ActiveMessageC;
	SplitControl = ActiveMessageC;
	LowPowerListening = ActiveMessageC;
	PacketAcknowledgements = ActiveMessageC;
	
	PacketTimeStampMilli = PacketTimeStampC;
	PacketTimeStamp32khz = PacketTimeStampC;
		
	TimeSyncAMSendMilli = PacketTimeSyncC;
	TimeSyncPacketMilli = PacketTimeSyncC;
	
	TimeSyncAMSend32khz = PacketTimeSyncC;
	TimeSyncPacket32khz = PacketTimeSyncC;
	
	Receive = PacketTimeSyncC.Receive;
	Snoop = PacketTimeSyncC.Snoop;
	AMPacket = PacketTimeSyncC;
	Packet = PacketTimeSyncC;
	
	// Only wire AM_TIMESYNCMSG if the application uses TimeSyncMessageC,
	// or it would conflict with apps like BaseStation, which wire all AM types
	// and cause fan-out of the Receive interface, which doesn't work.
	components new AMSenderC(AM_TIMESYNCMSG);
	PacketTimeSyncC.SubSend -> AMSenderC;
	PacketTimeSyncC.SubReceive -> ActiveMessageC.Receive[AM_TIMESYNCMSG];
	PacketTimeSyncC.SubSnoop -> ActiveMessageC.Snoop[AM_TIMESYNCMSG];
	
}
