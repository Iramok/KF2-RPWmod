//2017.6.11 gan����ĂŃ��[�v�e�X�g�A����

class StrafeWarp extends KFmutator;

var StrafeWarp_Mng SWMng;

//����
function ResetStartPoint(KFPlayerController KFPC) {
	SWMng.ResetStartPoint(KFPC);
}

//

//������
function Init() {
	SWMng = Spawn(class'StrafeWarp_Mng');
}

function WarpPC(KFPlayerController KFPC) {
	local NavigationPoint StartSpot;
//		StartSpot = MyKFGI.FindPlayerStart(KFPC);
//		StartSpot = MyKFGI.ChoosePlayerStart(KFPC);
	StartSpot = SWMng.GetStartPoint(KFPC);
	if (StartSpot!=None) {
		KFPC.Pawn.SetLocation(StartSpot.Location);
SendMessagePlayer(KFPC,"Warp! XD");
	}else{
//SendMessagePlayer(KFPC,"NonE!!!!!!!");
	}
//MyKFGI.SpawnManager.WaveTotalAI = 1;
//MyKFGI.MyKFGRI.AIRemaining = 1;
//MyKFGI.MyKFGRI.WaveTotalAICount = 1;
//SendMessagePlayer(KFPC,"test"$" remain::"$SWMng.Warp_UseNumRemain);
}

//�S���Ƀ��b�Z�[�W�𑗂�
function SendMessageAllPlayers(string Str) {
	local KFPlayerController KFPC;
	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC) {
		SendMessagePlayer(KFPC,Str);
	}
}

//�l�Ƀ��b�Z�[�W�𑗂�
function SendMessagePlayer(KFPlayerController KFPC,string Str) {
	KFPC.TeamMessage(KFPC.PlayerReplicationInfo,Str,'Event');
}