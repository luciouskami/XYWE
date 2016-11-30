#ifndef XYCameraIncluded
#define XYCameraIncluded

//! zinc
library XYCamera {
	public function XYPanCameraToTimedForPlayer(player plr, real x, real y, real duration) {
		if (GetLocalPlayer() == plr) {
			PanCameraToTimed(x, y, duration);
		}
	}
}
//! endzinc

#endif
