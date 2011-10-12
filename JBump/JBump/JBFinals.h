//
//  JBMapEntities.h
//  Playground
//
//  Created by Sebastian Pretscher on 08.10.11.
//

#ifndef __JB_MAP_ENTITIES_H
#define __JB_MAP_ENTITIES_H

#pragma mark General
#define jbID @"ID"
#define jbIMAGE @"Image"
#define jbIMAGELOCATION @"imageLocation"
#define jbIMAGEURL @"imageURL"
#define jbNAME @"name"
#define jbFURTHER @"further"
#define jbFRICTION @"friction"
#define jbRESTITUTION @"restitution"
#define jbDENSITY @"density"
#define jbPOSITION @"position"
#define jbSIZE @"size"
#define jbSHAPE @"shape"
#define jbTHUMBNAIL @"thumbnail"
#define jbTHUMBNAILLOCATION @"thumbnailLocation"
#define jbTHUMBNAILURL @"thumbnailURL"
#define jbINFO @"info"
#define jbDELETEBUTTON_TITLE @"Delete"

#pragma mark Entities
#define jbBODYTYPE @"bodyType"

#pragma mark Brush
#define jbRED @"red"
#define jbGREEN @"green"
#define jbBLUE @"blue"
#define jbALPHA @"alpha"

#pragma mark MapItem
#define jbSPRITE @"sprite"
#define jbMAPITEM @"mapItem"
#define jBMAPITEM_POINTS @"mapItem_points"

#pragma mark Skins

#pragma mark Map
#define jbBACKGROUNDIMAGE @"backgroundImage"
#define jbBACKGROUNDIMAGELOCATION @"backgroundImageLocation"
#define jbBACKGROUNDIMAGEURL @"backgroundImageURL"
#define jbARENAIMAGE @"arenaImage"
#define jbARENAIMAGELOCATION @"arenaImageLocation"
#define jbARENAIMAGEURL @"arenaImageURL"
#define jbOVERLAYIMAGE @"overlayImage"
#define jbOVERLAYIMAGELOCATION @"overlayImageLocation"
#define jbOVERLAYIMAGEURL @"overlayImageURL"
#define jbENTITIES @"entities"
#define jbCURVES @"curves"
#define jbSETTINGS @"settings"
#define jbHIGHTLIGHT_CROSS @"cross"
#define jbMAPPREFIX_CUSTOM @"C__"
#define jbMAPPREFIX_STANDARD @"S__"
#define jbMAPPREFIX_TDM @"T__"
#define jbMAPPREFIX_CTF @"F__"
#define jbMAPPREFIX_SOCCER @"B__"

#pragma mark Predefined Settings
#define jbMAPSETTINGS_SETTINGS @"settings"
#define jbMAPSETTINGS_DATA @"data"
#define jbMAPSETTINGS_GRAVITATION @"gravitation"
#define jbMAPSETTINGS_SOLIDFRICTION @"solid_friction"
#define jbMAPSETTINGS_TEAMS @"teams"
#define jbMAPSETTINGS_HERO_RESTITUTION @"hero_restitution"
#define jbMAPSETTINGS_HERO_ACCELERATION @"hero_acceleration"
#define jbMAPSETTINGS_HERO_MAXIMUM_SPEED @"hero_maximum_speed"
#define jbMAPSETTINGS_CAPTURE_THE_FLAG @"capture_the_flag"
#define jbMAPSETTINGS_SOCCER @"soccer"
#define jbMAPSETTINGS_DATA @"data"

#pragma mark Web Connection
#define jbWEB_CONNECTIONFAILED_TITLE @"connection failed"
#define jbWEB_CONNECTIONFAILED_MESSAGE @"Sry, not able to download the content"
#define jbWEB_CONNECTIONFAILED_OK @"OK"

#pragma mark Map Creator
#define jbMAPCREATOR_OFFX 180 
#define jbMAPCREATOR_OFFY 120

#pragma mark Map Creator Brushes
#define jbBRUSH_SOLID @"solid"
#define jbBRUSH_PLATFORM @"platform"
#define jbBRUSH_ICE @"ice"
#define jbBRUSH_DEATH @"death"
#define jbBRUSH_DOORLEFT @"doorleft"
#define jbBRUSH_DOORRIGHT @"doorright"
#define jbBRUSH_ASSEMBLYLEFT @"assemblyleft"
#define jbBRUSH_ASSEMBLYRIGHT @"assembleright"
#define jbBRUSH_HORIZONTAL_PLATFORM @"horizontal platform"

#pragma mark Map Creator Entities
#define jbENTITY_BODYTYPE_GHOST @"ghost"
#define jbENTITY_BODYTYPE_DENSE @"dense"
#define jbENTITY_SHAPE_CIRCLE @"circle"
#define jbENTITY_SHAPE_BOX @"box"

#pragma mark UserDefaults
#define jbUSERDEFAULTS_SKIN @"skinID"
#define jbUSERDEFAULTS_SHOW_SCOREBOARD @"jdShowScoreBoard"
#define jbUSERDEFAULTS_CUSTOM_SKIN_DOWNLOAD @"jdCustomSkinDownload"
#define jbUSERDEFAULTS_PLAYER_NAME_SIZE @"jdPlayerNameSizeValue"
#define jbUSERDEFAULTS_PLAYER_NAME @"jdPlayerName"

#pragma mark GameContext Keys
#define jbGAMECONTEXT_SKIN_ID @"skinID"
#define jbGAMECONTEXT_KILL_COUNT @"killCount"
#define jbGAMECONTEXT_DEATH_COUNT @"deathCount" 

#define PTM_RATIO 32.f
#define HERO_MAXIMUMSPEED 20.f
#endif