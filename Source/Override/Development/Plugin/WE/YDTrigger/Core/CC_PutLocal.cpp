#include "CC_Include.h"
#include "locvar.h"

char* pref[0x100];

typedef struct _tag_LocalVarList
{
	enum VARTYPE_User_Defined type;
	char* name;
}
LocalVarList;

LocalVarList g_local_var_list[0x100];
int  g_local_var_list_top;
BOOL g_local_in_mainproc;

int _fastcall
	CC_PutLocal_SaveAndCheck(DWORD OutClass, enum VARTYPE_User_Defined type, char* prefix, char* name)
{
	int i;

	for (i = 0; i < g_local_var_list_top; i++)
	{
		if (0 == BLZSStrCmp(name, g_local_var_list[i].name, 260))
			return FALSE;
	}

	if (g_local_var_list_top < 0x100)
	{
		pref[g_local_var_list_top] = prefix;
		g_local_var_list[g_local_var_list_top].name = name;
		g_local_var_list[g_local_var_list_top].type = type;
		g_local_var_list_top++;

		return TRUE;
	}

	return FALSE;
}

void _fastcall
	CC_PutLocal_LocalVar(DWORD OutClass, enum VARTYPE_User_Defined type, char* prefix, char* name)
{
	char buff[260];
	char name_covert[260];

	if (CC_PutLocal_SaveAndCheck(OutClass, type, prefix, name))
	{
		CC_PutBegin();
		ConvertString(name, name_covert, 260);
		if (prefix == "nopref")
		{
			if (TypeName[type] == "unitcode" || TypeName[type] == "itemcode" || TypeName[type] == "ablicode")
				BLZSStrPrintf(buff, 260, "local integer %s", name_covert);
			else if (TypeName[type] == "radian" || TypeName[type] == "degree")
				BLZSStrPrintf(buff, 260, "local real %s", name_covert);
			else
				BLZSStrPrintf(buff, 260, "local %s %s", TypeName[type], name_covert);
		}
		else
			BLZSStrPrintf(buff, 260, "local %s %s_%s", TypeName[type],prefix,name_covert);
		PUT_CONST(buff, 1);
		CC_PutEnd();
	}
}

void _fastcall
	CC_PutLocal_SearchVar(DWORD This, DWORD OutClass, BOOL isSearchHashLocal)
{
	DWORD nVarCount, i;
	DWORD nVarClass;

	nVarCount = *(DWORD*)(This+0x128);
	for (i = 0; i < nVarCount; i++)
	{
		nVarClass = GetGUIVar_Class(This, i);
		if (nVarClass != 0)
		{
			switch (*(DWORD*)(nVarClass+0x138))
			{
			case CC_GUIID_YDWEGetAnyTypeLocalVariable:
				if (isSearchHashLocal)
				{
					g_local_in_mainproc = TRUE;
				}
				break;
			default:
				break;
			}
			CC_PutLocal_SearchVar(nVarClass, OutClass, isSearchHashLocal);
		}    
	}
}

void _fastcall
	CC_PutLocal_Search(DWORD This, DWORD OutClass, DWORD isSearchHashLocal, LONG index)
{
	DWORD nItemCount, i;
	DWORD nItemClass;

	nItemCount = *(DWORD*)(This+0x0C);

	for (i = 0; i < nItemCount; i++)
	{
		nItemClass = ((DWORD*)(*(DWORD*)(This+0x10)))[i];
		if (*(DWORD*)(nItemClass+0x13C) == 0)
			continue;

		if ((index) != -1 && (*(LONG*)(nItemClass+0x154) != index))
			continue;

		CC_PutLocal_SearchVar(nItemClass, OutClass, isSearchHashLocal);

		switch (*(DWORD*)(nItemClass+0x138))
		{
		case CC_GUIID_IfThenElseMultiple:
		case CC_GUIID_ForLoopAMultiple:
		case CC_GUIID_ForLoopBMultiple:
		case CC_GUIID_ForLoopVarMultiple:
			CC_PutLocal_Search(nItemClass, OutClass, isSearchHashLocal, -1);
			break;      
		case CC_GUIID_YDWEForLoopLocVarMultiple:
			CC_PutLocal_LocalVar(OutClass, CC_TYPE_integer, "ydul", ((char*)&GetGUIVar_Value(nItemClass, 0)));
			CC_PutLocal_Search(nItemClass, OutClass, isSearchHashLocal, -1);
			break;
		case CC_GUIID_YDWERegionMultiple:
			CC_PutLocal_Search(nItemClass, OutClass, isSearchHashLocal, -1);
			break;
		case CC_GUIID_EnumDestructablesInRectAllMultiple:
		case CC_GUIID_EnumDestructablesInCircleBJMultiple:
		case CC_GUIID_EnumItemsInRectBJMultiple:
			if (isSearchHashLocal)
			{
				CC_PutLocal_Search(nItemClass, OutClass, isSearchHashLocal, -1);
			}
			break;
		case CC_GUIID_ForGroupMultiple:
		case CC_GUIID_YDWEEnumUnitsInRangeMultiple:
			CC_PutLocal_LocalVar( OutClass, CC_TYPE_group,  "ydl", "group");
			CC_PutLocal_LocalVar( OutClass, CC_TYPE_unit,  "ydl", "unit");
			CC_PutLocal_Search(nItemClass, OutClass, isSearchHashLocal, 0);
			break;
		case CC_GUIID_YDWETimerStartMultiple:
			CC_PutLocal_LocalVar( OutClass, CC_TYPE_timer,  "ydl", "timer");
			CC_PutLocal_Search(nItemClass, OutClass, isSearchHashLocal, 0);
			break; 
		case CC_GUIID_YDWERegisterTriggerMultiple:
			CC_PutLocal_LocalVar( OutClass, CC_TYPE_trigger, "ydl", "trigger");
			CC_PutLocal_Search(nItemClass, OutClass, isSearchHashLocal, 0);
			break; 
		case CC_GUIID_YDWESetAnyTypeLocalVariable:
			if (isSearchHashLocal)
			{
				g_local_in_mainproc = TRUE;
			}
			break;
		case CC_GUIID_SetJassLocalVariables:
			CC_PutLocal_LocalVar(OutClass, (VARTYPE_User_Defined)GetVarType(nItemClass, 0), "nopref",((char*)&GetGUIVar_Value(nItemClass, 1)));
			CC_PutLocal_Search(nItemClass, OutClass, isSearchHashLocal, 0);
			break;
		default:
			break;           
		}
	}
}

void _fastcall
	CC_PutLocal_Begin(DWORD This, DWORD OutClass, DWORD isTimer, DWORD isSearchHashLocal)
{
	g_local_var_list_top = 0;

	if (isSearchHashLocal)
	{
		g_local_in_mainproc = FALSE;
	}

	CC_PutLocal_Search(This, OutClass, isSearchHashLocal, -1);

	if (!isTimer && isSearchHashLocal)
	{
		locvar::construct(OutClass);
	}
}

void _fastcall
	CC_PutLocal_End(DWORD This, DWORD OutClass, DWORD isTimer, DWORD isEnd)
{
	int i;
	char buff[260];
	char name_covert[260];

	if (!isTimer)
	{
		locvar::destroy(OutClass);
	} 

	for (i = 0; i < g_local_var_list_top; i++)
	{
		switch (g_local_var_list[i].type)
		{
		// auto set null list
		case CC_TYPE_unit:
		case CC_TYPE_group:
		case CC_TYPE_timer:
		case CC_TYPE_trigger:
		case CC_TYPE_force:
		case CC_TYPE_item:
		case CC_TYPE_location:
		case CC_TYPE_destructable:
		case CC_TYPE_rect:
		case CC_TYPE_region:
		case CC_TYPE_effect:
		case CC_TYPE_unitpool:
		case CC_TYPE_itempool:
		case CC_TYPE_quest:
		case CC_TYPE_questitem:
		case CC_TYPE_timerdialog:
		case CC_TYPE_leaderboard:
		case CC_TYPE_multiboard:
		case CC_TYPE_multiboarditem:
		case CC_TYPE_trackable:
		case CC_TYPE_dialog:
		case CC_TYPE_button:
		case CC_TYPE_fogstate:
		case CC_TYPE_fogmodifier:
			CC_PutBegin();
			ConvertString(g_local_var_list[i].name, name_covert, 260);
			if (pref[i] == "nopref")
				BLZSStrPrintf(buff, 260, "set %s = null",name_covert);
			else
				BLZSStrPrintf(buff, 260, "set %s_%s = null", pref[i], name_covert);
			PUT_CONST(buff,1);
			CC_PutEnd();
			break;
		}
	}

	if (isEnd)
	{
		g_local_var_list_top = 0;
		g_local_in_mainproc = FALSE;
	}
}