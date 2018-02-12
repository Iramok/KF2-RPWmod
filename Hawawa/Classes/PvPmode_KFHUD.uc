
class PvPmode_KFHUD extends KFGFxHudWrapper;

//PvPmode_KFHUD�p
var bool bUsePvPHUD;
var float TimeLastChanged;

//�O����
simulated function  PostBeginPlay() {
	super.PostBeginPlay();
	//HUD
		bUsePvPHUD = true;
		TimeLastChanged = WorldInfo.TimeSeconds;
	//
}

//�^�C�}�[�̒������擾
function float GetTimerLength() {
	if (bUsePvPHUD) {
		return class'PvPMode'.default.TimerLength_MyHUD;
	}else{
		return class'PvPMode'.default.TimerLength_TWIHUD;
	}
}

//HUD�̕ύX���Ԃ��Ď�
function CheckTimeToChangeHUD() {
	if (`TimeSince(TimeLastChanged) > GetTimerLength()) {
		TimeLastChanged = WorldInfo.TimeSeconds;
		bUsePvPHUD = bUsePvPHUD ? false : true;
//SendMessagePlayer("change:"$bUsePvPHUD);
	}
}

//�v���C���[�̏��\���Ȃ�ĂȂ�����
simulated function bool DrawFriendlyHumanPlayerInfo( KFPawn_Human KFPH ) {
	return false;
//	CheckTimeToChangeHUD();
//	return ( bUsePvPHUD ? false : super.DrawFriendlyHumanPlayerInfo(KFPH) ) ;
}

//�A�C�R���\���Ȃ�ĂȂ�����
function DrawHiddenHumanPlayerIcon( PlayerReplicationInfo PRI, vector IconWorldLocation ) {
	CheckTimeToChangeHUD();
	if (!bUsePvPHUD) super.DrawHiddenHumanPlayerIcon(PRI,IconWorldLocation);
}

//�l�Ƀ��b�Z�[�W�𑗂�
function SendMessagePlayer(string Str) {
	KFPlayerOwner.TeamMessage(KFPlayerOwner.PlayerReplicationInfo,Str,'Event');
}