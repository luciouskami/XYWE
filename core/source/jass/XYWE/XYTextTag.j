#ifndef XYTextTagIncluded
#define XYTextTagIncluded

#include "XYWE/XYGlobalVariable.j"

//! zinc
library XYTextTag requires XYGlobalVariable {
	public function XYCreateTextTagForAll(real x, real y,string s,integer r,integer g,integer b,integer al,real d,real h,real vx,real vy,real z,boolean l) -> texttag {
		texttag tt = CreateTextTag();
		SetTextTagPos(tt, x, y, h);
		SetTextTagPermanent(tt, l);
		SetTextTagLifespan(tt, z);
		SetTextTagText(tt, s, d * 0.0023);
		SetTextTagVelocity(tt, vx, vy);
		SetTextTagColor(tt, r, g, b, al);
		bj_lastCreatedTextTag = tt;
		return tt;
	}
	/*
	public function XYCreateTextTagForForce(force f,real x, real y,string s,integer r,integer g,integer b,integer al,real d,real h,real vx,real vy) {
		//XYCreateTextTagForForce="为指定玩家组创建漂浮(指定坐标) [X]"
		//	XYCreateTextTagForForce="为 "~玩家组," 创建漂浮文字在坐标 (",~x,","~y,") ，文字内容为 "~字符串," ，颜色值 (",~R,",",~G,","~B,",",~A,") ，大小 "~实数," ，高度 "~实数," ，速率 (",~实数,","~实数,")"
		//	XYCreateTextTagForForceHint="目前无法使用'最后创建的漂浮文字'捕获. 颜色值为红,绿,蓝,alpha通道,在0-255之间,最后一项填0则不显示。"
		//CreateTextTagForForce=0,force,real,real,string,integer,integer,integer,integer,real,real,real,real,real,boolean
		//	_CreateTextTagForForce_Defaults=GetPlayersAll,GetRectCenterX,GetRectCenterY,_,255,255,255,255,10,0,0,0,3,false
		//	_CreateTextTagForForce_Limits=_,_,_,_,_,_,_,_,0,255,0,255,0,255,0,255,0,_,_,_,_,_,_,_,0,_,_,_
		//	_CreateTextTagForForce_Category=TC_TEXTTAG
		XYGV_real[0] = x; XYGV_real[1] = y;
		XYGV_string[0] = s;
		XYGV_integer[0] = r; XYGV_integer[1] = g; XYGV_integer[2] = b;
		XYGV_integer[3] = al;
		XYGV_real[2] = d; XYGV_real[3] = h; XYGV_real[4] = vx; XYGV_real[5] = vy;
		ForForce(f, function(){
			texttag tt;
			real x = XYGV_real[0]; real y = XYGV_real[1];
			string s = XYGV_string[0];
			integer r = XYGV_integer[0]; integer g = XYGV_integer[1]; integer b = XYGV_integer[2];
			integer al = XYGV_integer[3];
			real d = XYGV_real[2]; real h = XYGV_real[3]; real vx = XYGV_real[4]; real vy = XYGV_real[5];
			if (GetEnumPlayer() == GetLocalPlayer()) {
				tt = CreateTextTag();
				SetTextTagPos(tt, x, y, h);
				SetTextTagPermanent(tt, true);
				SetTextTagLifespan(tt, z);
				SetTextTagText(tt, s, d*0.0023);
				SetTextTagVelocity(tt, vx, vy);
				SetTextTagColor(tt, r, g, b, al);
			}
		});
	}
	*/
}
//! endzinc

#endif
