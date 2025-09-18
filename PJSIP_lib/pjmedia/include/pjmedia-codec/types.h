/* $Id$ */
/* 
 * Copyright (C) 2008-2011 Teluu Inc. (http://www.teluu.com)
 * Copyright (C) 2003-2008 Benny Prijono <benny@prijono.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
 */
#ifndef __PJMEDIA_CODEC_TYPES_H__
#define __PJMEDIA_CODEC_TYPES_H__

/**
 * @file types.h
 * @brief PJMEDIA-CODEC types and constants
 */

#include <pjmedia-codec/config.h>
#include <pjmedia/codec.h>

/**
 * @defgroup pjmedia_codec_types PJMEDIA-CODEC Types and Constants
 * @ingroup PJMEDIA_CODEC
 * @brief Constants used by PJMEDIA-CODEC
 * @{
 */



/**
 * These are the dynamic payload types that are used by audio codecs in
 * this library. Also see the header file <pjmedia/codec.h> for list
 * of static payload types.
 *
 * These enumeration is for older audio codecs only, newer audio codec using
 * dynamic payload type can simply assign PJMEDIA_RTP_PT_DYNAMIC in its
 * payload type (i.e: pjmedia_codec_info.pt). Endpoint will automatically
 * rearrange dynamic payload types in SDP generation.
 */
#if defined(PJMEDIA_RTP_USE_OUR_PT) && (PJMEDIA_RTP_USE_OUR_PT!=0)

/*
 for buggy Asterisk 11 with directmedia problems
 https://issues.asterisk.org/jira/browse/ASTERISK-17410

 Asterisk 11 Dynamic payload types
 https://github.com/asterisk/asterisk/blob/11/main/rtp_engine.c

 add_static_payload(97, ast_format_set(&tmpfmt, AST_FORMAT_ILBC, 0), 0);
 add_static_payload(98, ast_format_set(&tmpfmt, AST_FORMAT_H263_PLUS, 0), 0);
 add_static_payload(99, ast_format_set(&tmpfmt, AST_FORMAT_H264, 0), 0);
 add_static_payload(101, NULL, AST_RTP_DTMF);
 add_static_payload(102, ast_format_set(&tmpfmt, AST_FORMAT_SIREN7, 0), 0);
 add_static_payload(103, ast_format_set(&tmpfmt, AST_FORMAT_H263_PLUS, 0), 0);
 add_static_payload(104, ast_format_set(&tmpfmt, AST_FORMAT_MP4_VIDEO, 0), 0);
 add_static_payload(105, ast_format_set(&tmpfmt, AST_FORMAT_T140RED, 0), 0);   // Real time text chat (with redundancy encoding)
add_static_payload(106, ast_format_set(&tmpfmt, AST_FORMAT_T140, 0), 0);     // Real time text chat
add_static_payload(110, ast_format_set(&tmpfmt, AST_FORMAT_SPEEX, 0), 0);
add_static_payload(111, ast_format_set(&tmpfmt, AST_FORMAT_G726, 0), 0);
add_static_payload(112, ast_format_set(&tmpfmt, AST_FORMAT_G726_AAL2, 0), 0);
add_static_payload(115, ast_format_set(&tmpfmt, AST_FORMAT_SIREN14, 0), 0);
add_static_payload(116, ast_format_set(&tmpfmt, AST_FORMAT_G719, 0), 0);
add_static_payload(117, ast_format_set(&tmpfmt, AST_FORMAT_SPEEX16, 0), 0);
add_static_payload(118, ast_format_set(&tmpfmt, AST_FORMAT_SLINEAR16, 0), 0); // 16 Khz signed linear
add_static_payload(119, ast_format_set(&tmpfmt, AST_FORMAT_SPEEX32, 0), 0);
add_static_payload(121, NULL, AST_RTP_CISCO_DTMF);   // Must be type 121

 range: 96-127
 101, 121 dtmf
 98, 99, 100 video
 */

#define PJMEDIA_RTP_PT_START = (PJMEDIA_RTP_PT_DYNAMIC-1)

// synced with Askerisk 11
#define PJMEDIA_RTP_PT_ILBC 97
#define PJMEDIA_RTP_PT_OPUS 111
#define PJMEDIA_RTP_PT_SPEEX_NB 110
#define PJMEDIA_RTP_PT_SPEEX_WB 117
#define PJMEDIA_RTP_PT_SPEEX_UWB 119
#define PJMEDIA_RTP_PT_L16_16KHZ_MONO 118

// not synced with Askerisk
#define PJMEDIA_RTP_PT_SILK_NB 96
#define PJMEDIA_RTP_PT_G722_1_16 102
#define PJMEDIA_RTP_PT_G722_1_24 103
#define PJMEDIA_RTP_PT_G722_1_32 104
#define PJMEDIA_RTP_PT_G7221C_24 105
#define PJMEDIA_RTP_PT_G7221C_32 106
#define PJMEDIA_RTP_PT_G7221C_48 107
#define PJMEDIA_RTP_PT_G7221_RSV1 108
#define PJMEDIA_RTP_PT_G7221_RSV2 109
#define PJMEDIA_RTP_PT_SILK_MB 114
#define PJMEDIA_RTP_PT_SILK_WB 115
#define PJMEDIA_RTP_PT_SILK_SWB 112
#define PJMEDIA_RTP_PT_GSMEFR 113
#define PJMEDIA_RTP_PT_AMR 120
#define PJMEDIA_RTP_PT_AMRWB 122
#define PJMEDIA_RTP_PT_L16_8KHZ_MONO 123
#define PJMEDIA_RTP_PT_L16_8KHZ_STEREO 124
#define PJMEDIA_RTP_PT_L16_16KHZ_STEREO 125
#define PJMEDIA_RTP_PT_L16_48KHZ_MONO 126
#define PJMEDIA_RTP_PT_L16_48KHZ_STEREO 127

#else

enum pjmedia_audio_pt
{
    /* According to IANA specifications, dynamic payload types are to be in
     * the range 96-127 (inclusive), but this enum allows the value to be
     * outside that range, later endpoint will rearrange dynamic payload types
     * in SDP generation to be inside the 96-127 range and not equal to
     * PJMEDIA_RTP_PT_TELEPHONE_EVENTS.
     *
     * PJMEDIA_RTP_PT_DYNAMIC is defined in <pjmedia/codec.h>. It is defined
     * to be 96.
     */
    PJMEDIA_RTP_PT_START = (PJMEDIA_RTP_PT_DYNAMIC-1),

    PJMEDIA_RTP_PT_SPEEX_NB,			/**< Speex narrowband/8KHz  */
    PJMEDIA_RTP_PT_SPEEX_WB,			/**< Speex wideband/16KHz   */
    PJMEDIA_RTP_PT_SPEEX_UWB,			/**< Speex 32KHz	    */
    PJMEDIA_RTP_PT_SILK_NB,			/**< SILK narrowband/8KHz   */
    PJMEDIA_RTP_PT_SILK_MB,			/**< SILK mediumband/12KHz  */
    PJMEDIA_RTP_PT_SILK_WB,			/**< SILK wideband/16KHz    */
    PJMEDIA_RTP_PT_SILK_SWB,			/**< SILK 24KHz		    */
    PJMEDIA_RTP_PT_ILBC,			/**< iLBC (13.3/15.2Kbps)   */
    PJMEDIA_RTP_PT_AMR,				/**< AMR (4.75 - 12.2Kbps)  */
    PJMEDIA_RTP_PT_AMRWB,			/**< AMRWB (6.6 - 23.85Kbps)*/
    PJMEDIA_RTP_PT_AMRWBE,			/**< AMRWBE		    */
    PJMEDIA_RTP_PT_G726_16,			/**< G726 @ 16Kbps	    */
    PJMEDIA_RTP_PT_G726_24,			/**< G726 @ 24Kbps	    */
    PJMEDIA_RTP_PT_G726_32,			/**< G726 @ 32Kbps	    */
    PJMEDIA_RTP_PT_G726_40,			/**< G726 @ 40Kbps	    */
    PJMEDIA_RTP_PT_G722_1_16,			/**< G722.1 (16Kbps)	    */
    PJMEDIA_RTP_PT_G722_1_24,			/**< G722.1 (24Kbps)	    */
    PJMEDIA_RTP_PT_G722_1_32,			/**< G722.1 (32Kbps)	    */
    PJMEDIA_RTP_PT_G7221C_24,			/**< G722.1 Annex C (24Kbps)*/
    PJMEDIA_RTP_PT_G7221C_32,			/**< G722.1 Annex C (32Kbps)*/
    PJMEDIA_RTP_PT_G7221C_48,			/**< G722.1 Annex C (48Kbps)*/
    PJMEDIA_RTP_PT_G7221_RSV1,			/**< G722.1 reserve	    */
    PJMEDIA_RTP_PT_G7221_RSV2,			/**< G722.1 reserve	    */
    PJMEDIA_RTP_PT_OPUS,			/**< OPUS                   */
#if PJMEDIA_CODEC_L16_HAS_8KHZ_MONO
    PJMEDIA_RTP_PT_L16_8KHZ_MONO,		/**< L16 @ 8KHz, mono	    */
#endif
#if PJMEDIA_CODEC_L16_HAS_8KHZ_STEREO
    PJMEDIA_RTP_PT_L16_8KHZ_STEREO,		/**< L16 @ 8KHz, stereo     */
#endif
    //PJMEDIA_RTP_PT_L16_11KHZ_MONO,		/**< L16 @ 11KHz, mono	    */
    //PJMEDIA_RTP_PT_L16_11KHZ_STEREO,		/**< L16 @ 11KHz, stereo    */
#if PJMEDIA_CODEC_L16_HAS_16KHZ_MONO
    PJMEDIA_RTP_PT_L16_16KHZ_MONO,		/**< L16 @ 16KHz, mono	    */
#endif
#if PJMEDIA_CODEC_L16_HAS_16KHZ_STEREO
    PJMEDIA_RTP_PT_L16_16KHZ_STEREO,		/**< L16 @ 16KHz, stereo    */
#endif
    //PJMEDIA_RTP_PT_L16_22KHZ_MONO,		/**< L16 @ 22KHz, mono	    */
    //PJMEDIA_RTP_PT_L16_22KHZ_STEREO,		/**< L16 @ 22KHz, stereo    */
    //PJMEDIA_RTP_PT_L16_32KHZ_MONO,		/**< L16 @ 32KHz, mono	    */
    //PJMEDIA_RTP_PT_L16_32KHZ_STEREO,		/**< L16 @ 32KHz, stereo    */
#if PJMEDIA_CODEC_L16_HAS_48KHZ_MONO
    PJMEDIA_RTP_PT_L16_48KHZ_MONO,		/**< L16 @ 48KHz, mono	    */
#endif
#if PJMEDIA_CODEC_L16_HAS_48KHZ_STEREO
    PJMEDIA_RTP_PT_L16_48KHZ_STEREO,		/**< L16 @ 48KHz, stereo    */
#endif
};

#endif

/**
 * These are the dynamic payload types that are used by video codecs in
 * this library.
 */
#if defined(PJMEDIA_RTP_USE_OUR_PT) && (PJMEDIA_RTP_USE_OUR_PT!=0)

// for buggy Asterisk 11 with directmedia problems
// https://issues.asterisk.org/jira/browse/ASTERISK-17410

#define PJMEDIA_RTP_PT_H263P 98
#define PJMEDIA_RTP_PT_H264 102
#define PJMEDIA_RTP_PT_VP8 100
#define PJMEDIA_RTP_PT_VP9 101
#define PJMEDIA_RTP_PT_H264_RSV3 99

/*
Asterisk PBX 11.5.1 codecs:
a=rtpmap:31 H261/90000

a=rtpmap:34 H263/90000
a=fmtp:34 F=0;I=0;J=0;T=0;K=0;N=0;BPP=0;HRD=0

a=rtpmap:98 h263-1998/90000
a=fmtp:98 QCIF=1;CIF=1;F=0;I=0;J=0;T=0;K=0;N=0;BPP=0;HRD=0

a=rtpmap:99 H264/90000
a=fmtp:99 profile-level-id=42E01E

a=rtpmap:104 MP4V-ES/90000
*/

#else

enum pjmedia_video_pt
{
     /* Video payload types */
     PJMEDIA_RTP_PT_VID_START = (PJMEDIA_RTP_PT_DYNAMIC-1),
     PJMEDIA_RTP_PT_H263P,      /* used by ffmpeg avcodec     */
     PJMEDIA_RTP_PT_H264,       /* used by OpenH264           */
     PJMEDIA_RTP_PT_H264_RSV1,  /* used by video toolbox      */
     PJMEDIA_RTP_PT_H264_RSV2,  /* used by MediaCodec         */
     PJMEDIA_RTP_PT_H264_RSV3,  /* used by ffmpeg avcodec     */
     PJMEDIA_RTP_PT_H264_RSV4,

     PJMEDIA_RTP_PT_VP8,        /* used by VPX                */
     PJMEDIA_RTP_PT_VP8_RSV1,   /* used by MediaCodec         */
     PJMEDIA_RTP_PT_VP8_RSV2,
     PJMEDIA_RTP_PT_VP9,        /* used by VPX                */
     PJMEDIA_RTP_PT_VP9_RSV1,   /* used by MediaCodec         */
     PJMEDIA_RTP_PT_VP9_RSV2,

     /* Caution!
      * Ensure the value of the last pt above is <= 127.
      */
};

#endif

/**
 * @}
 */


#endif	/* __PJMEDIA_CODEC_TYPES_H__ */
