class WinMatch extends KFMutator;

//const VoteDuration = 6.f; //10��*60
const VoteDuration = 6000.f; //10��*60
const DieTime = 1.0f; //ready���Ă��玀�ʂ܂ł̎���

function PostBeginPlay() {
	super.PostBeginPlay();
	//�^�C�}�[
		settimer(1.f ,true, nameof(DoPlayerReady));
	//Map���[�̎��Ԃ������ăI����
		MyKFGI.MapVoteDuration = VoteDuration;
	//
}

function DoPlayerReady() {
	local KFPlayerController KFPC;
	local KFPlayerReplicationInfo KFPRI;
	if (!MyKFGI.MyKFGRI.bMatchHasBegun) {
		foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC) {
			KFPRI = KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo);
			KFPRI.SetPlayerReady(true);
		}
		//roop==false: ���Ɏ��E�ł��Ȃ��Ă�zed�ɏP����ł���
		settimer(DieTime ,false, nameof(DoPlayerDie));
	}
}

function DoPlayerDie() {
	local KFPlayerController KFPC;
	if (MyKFGI.MyKFGRI.bMatchHasBegun) {
		//Ready�̕K�v�Ȃ�
			SetTimer(0.f ,false, nameof(DoPlayerReady));
		//
		foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC) {
			KFPC.Pawn.FellOutOfWorld(none);
		}
	}
}