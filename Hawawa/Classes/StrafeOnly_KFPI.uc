class StrafeOnly_KFPI extends KFPlayerInput;

// Overridden to not double apply FOV scaling
event PlayerInput( float DeltaTime )
{
	//�g���[�_�[�^�C���̓J�j��������
		if (IsTraderOpened()) {
			Super.PlayerInput(DeltaTime);
			return;
		}
	//����������I�ɖ���
		if (bRun!=0) {
			GamepadSprintRelease();
		}
	//�����I�ɂ��Ⴊ�܂���
		if (!Pawn.bIsCrouched) {
			StartCrouch();
		}
	//�]���̓��͏�����A�����I�ɑO������̓��͂𖳌���
		Super.PlayerInput(DeltaTime);
		aForward	= 0.f;
		//Pawn.Health = 42;
}

/** Abort/Cancel crouch when jumping */
exec function Jump(){
	//ZED�^�C���y�уg���[�_�[�^�C���̓J�j��������
	if ( (WorldInfo.TimeDilation<1.f) || (IsTraderOpened()) ) {
		Super.Jump();
		return;
	}
}

function bool IsTraderOpened() {
	local KFTraderTrigger KFTT;
	KFTT = KFGameReplicationInfo(WorldInfo.GRI).OpenedTrader;
	if (KFTT==None) return false;
	return KFTT.bOpened;
}